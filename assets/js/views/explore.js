import MainView from './main';

export default class View extends MainView {
    mount() {
        super.mount();       
        var selected_categories = [];
        var selected_project_state = [];
        var selected_impact = [];
        var selected_communities = [];
        let currentPage = 0;

        if (currentPage == 0)
            $('.prev-page').addClass("disabled");

        $('.next-page').on('click', function(e){
            e.preventDefault();
            getProjects(++currentPage);
        });

        $('.prev-page').on('click', function(e){
            e.preventDefault();
            getProjects(--currentPage);
        });

        function getParameterByName(name)
        {
          name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
          var regexS = "[\\?&]" + name + "=([^&#]*)";
          var regex = new RegExp(regexS);
          var results = regex.exec(window.location.search);
          if(results == null)
            return "";
          else
            return decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        if (getParameterByName("order") != undefined){
             $("#orderby").val(getParameterByName("order")).attr('selected', true);;
        }

        $(".filter-dropdown-categories").click(function(){
            $(".list-categories").toggle("slow");
        });

        $(".filter-dropdown-communities").click(function(){
            $(".list-communities").toggle("slow");
        });

        $(".ui.dividing.header.state").click(function(){
            $(".list-state-mobile").toggle("slow");
        });

        $(".ui.dividing.header.impact").click(function(){
            $(".list-impact-mobile").toggle("slow");
        });

        $(".ui.dividing.header.category").click(function(){
            $(".list-categories-mobile").toggle("slow");
        });

        $(".ui.dividing.header.community").click(function(){
            $(".list-communities-mobile").toggle("slow");
        });

        $('#orderby').change(function(){
            getAllProjects();
        });

        $(".ui.checkbox > label").on('click', function(){
            $(this).prev().click();
        })

        $("input[type=checkbox]").click(function(){
        
            $(this).next().toggleClass("checked");

            selected_categories = [];
            selected_project_state = [];
            selected_impact = [];
            selected_communities = [];

            $("input.project-state[type=checkbox]:checked").each(function(){
                selected_project_state.push($(this).attr('name'));
            });

            $("input.project-impact[type=checkbox]:checked").each(function(){
                selected_impact.push($(this).attr('name'));
            });

            $("input.project-category[type=checkbox]:checked").each(function(){
                selected_categories.push($(this).attr('name'));
            });

            $("input.project-community[type=checkbox]:checked").each(function(){
                selected_communities.push($(this).attr('name'));
            });

            getAllProjects();
        });

        function getProjects(page){
            let  csrf = $("meta[name=\"csrf\"]").attr("content");
            let order = $("#orderby").find("option:selected").attr('value');
            let name =  $("#name-project").val();

            $.ajax({
                type: 'GET',
                url: '/api/v1/explore',
                data: {order: order, state: selected_project_state, impact: selected_impact, category: selected_categories, community: selected_communities, name: name, page:page},
                "headers": {
                    "X-CSRF-TOKEN": csrf
                },
                success: function(projects) {
                    if (projects.length == 0 && currentPage == 0){
                        $('.next-page').addClass("disabled");
                        $('.pagination').hide();
                    }
                    /* No next page */
                    else if (projects.length <= 6){
                        $('.pagination').show();
                        $('.next-page').addClass("disabled");
                        if (currentPage == 0)
                            $('.pagination').hide();
                    }
                    else{
                        $('.pagination').show();
                        $('.next-page').removeClass("disabled")
                    }

                    $(".ui.grid.stackable.projects .project").remove();

                    for(let i = 0; i < 6; i++){
                        let project = projects[i]
                        switch(project["state"]){
                            case "presentation":
                                var icon = '<i class="puzzle basket icon huge"></i>';
                            break;

                            case 'funding':
                                var icon = '<i class="shopping basket icon huge"></i>';
                            break;

                            case 'creation':
                                var icon = '<i class="paint brush icon"></i>';
                            break;
                        }

                        if(project["photo"]==null)
                            var image = '/images/default-project-image.png';
                        else{
                            var image = project["photo"];
                            image = image.trim().replace(/ /g, '%20');
                        }

                        let percentage = Math.round(100 * project["current_fund"]/project["fund_asked"]);
                        let url = "'/project/show/"+ project["id"] + "'";
                        $(".ui.grid.stackable.projects").append('<div class="five wide column project" onclick="window.location.href='+ url +'"><div class="ui fluid image project-image">'+
                        '<img class="ui centered image " src='+ image +'>'+
                        '<div class="ui ribbon label">'+ project["category"].toUpperCase() + '</div></div>'
                        + '<div class="project-phase">' + icon + project["state"].toUpperCase() + '</div>'
                        + '<div class="project-title">'+project["vision_name"]+'</div>'
                        + '<div class="project-phase-description">'+project["vision"]+'</div>'
                        + '<div class="funding-state"><div id="progress" class="ui progress blue" data-total="100" data-percent="'+ percentage +'"><div class="bar" style="width:'+ percentage +'%"><div class="progress"></div>'
                        + '</div></div></div>'
                        + '<div class="project-presentation">' + percentage + '% </div>'
                        +'</div>');
                    }
                }
            });

            if (currentPage == 0)
                $('.prev-page').addClass("disabled");
            else
                $('.prev-page').removeClass("disabled")
        }

        function getAllProjects(){
            currentPage = 0;

            if($('input[type=checkbox]:checked').length == 0){
                selected_categories = [];
                selected_project_state = ['presentation', 'funding', 'creation'];
                selected_impact = ['regional', 'national', 'international', 'global'];
                selected_communities = [];
            }

            if(selected_impact.length==0 && selected_project_state.length==0 ){
                selected_impact = ['regional', 'national', 'international', 'global'];
                selected_project_state = ['presentation', 'funding', 'creation'];
            }

            getProjects(currentPage);
        }
    }
    unmount() {
        super.unmount();
    }
}
