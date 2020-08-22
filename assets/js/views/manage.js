import ManageView from './main';

export default class View extends ManageView {
  mount() {
    super.mount();

    var isComputer = true;
    var classCommunity = "";

    function getManage(){

        let  csrf = $("meta[name=\"csrf\"]").attr("content");
        
        $.ajax({
            type: 'GET',
            url: '/api/v1/manage/communities',
            data: {},
            "headers": {
                "X-CSRF-TOKEN": csrf
            },
            success: function(communities) {
                let firstCommunity;

                for(let index in communities){

                    let communityClass="ui dividing header general-information";
                    if(index == 0){
                        communityClass+=" selected-header";
                        firstCommunity=communities[index]["id"];
                    }
                    
                    $('.communities-user').append('<h4 id='+communities[index]["id"]+' class="'+communityClass+'">'
                    + communities[index]["name"]
                    + '<i class="angle right icon"></i>'
                    + '</h4>');

                    $('.communities-user-mobile').append('<div class="row community-projects-mobile">'
                    +   '<a id='+communities[index]["id"]+' class="item general-information-mobile selected-header">'
                    +   communities[index]["name"]
                    +   '<i class="angle down icon"></i>'
                    +   '</a>'
                    +   '<div  id=projects_'+communities[index]["id"]+' class="tohide ui grid">'
                    +   '</div>'
                    +   '</div>');
                }

                $('.general-information').click(function(e){
                    getCommunityProjects($(this).attr("id"));
                    $(".selected-header").removeClass("selected-header");
                    $(this).addClass("selected-header");
                });

                $('.general-information-mobile').click(function(e){
                    let idCommunity = $(this).attr("id");
                    getCommunityProjectMobile(idCommunity);
                });

                getCommunityProjects(firstCommunity);
            }
        });
    }

    function updateProjectAcceptance(projectID){
        let  csrf = $("meta[name=\"csrf\"]").attr("content");
        
        $.ajax({
            type: 'PUT',
            url: '/api/v1/manage/updateAcceptance',
            data: {id: projectID},
            "headers": {
                "X-CSRF-TOKEN": csrf
            },
            success: function(res) {

            }
        });
    }

    function deleteProject(projectID){
        let csrf = $("meta[name=\"csrf\"]").attr("content");

        let apiUrl = 'api/v1/manage/deleteProject/'+projectID;
        $.ajax({
            type: 'PUT',
            url: apiUrl,
            "headers": {
                "X-CSRF-TOKEN": csrf
            },
            success: function(res) {
                
            }
        });
    }

    function getCommunityProjects(id){

        let  csrf = $("meta[name=\"csrf\"]").attr("content");

        $.ajax({
            type: 'GET',
            url: '/api/v1/manage/projects',
            data: {id: id},
            "headers": {
                "X-CSRF-TOKEN": csrf
            },
            success: function(projects) {
                $('.projects-community-row').html("");

                if(projects.length == 0){
                    $('.projects-community-row').append('<div class="row">'
                    + '<div class="sixteen wide column no projects">'
                    + 'No projects to be accepted in this community.'
                    + '</div>'
                    + '</div>');
                } else {
                    var projs = new Set();
                    for(let index in projects){
                        if(projs.has(projects[index]["id"])){
                            continue;
                        }

                        projs.add(projects[index]["id"]);

                        let url = "'/project/show/"+ projects[index]["id"] + "'";

                        $('.projects-community-row').append('<div class="row '+projects[index]["id"]+'">'
                        + '<div class="three wide column">'
                        + '<img class="ui centered circular image" src="'+projects[index]["image_path"]+'">'
                        + '</div>'
                        + '<div class="ui middle aligned ten wide column">'
                        + '<a onclick="window.location.href='+ url +'">'
                        + projects[index]["vision_name"]
                        + '</a>'
                        + '</div>'
                        + '<div class="three wide column state-options">'
                        + '<button id="'+projects[index]["id"]+'" class="ui icon button change-state accept">'
                        + '<i class="checkmark icon"></i>'
                        + '</button>'
                        + '<button id="'+projects[index]["id"]+'" class="ui icon button change-state remove">'
                        + '<i class="remove icon"></i>'
                        + '</button>'
                        + '</div>'
                        + '</div>'
                        + '<div class="sixteen wide column ui divider '+projects[index]["id"]+'"></div>');
                    }
                }

                $('.change-state.accept').click(function(e){
                    let id = $(this).attr("id");
                    let key="div."+id;
                    $(key).remove();
                    updateProjectAcceptance(id);
                });

                $('.change-state.remove').click(function(e){
                    let id = $(this).attr("id");
                    let key ="div."+id;
                    $(key).remove();
                    deleteProject(id);
                });
            }
        });
    }

    function getCommunityProjectMobile(id){

        let newClassCommunity = "#projects_"+id;
        
        if(classCommunity != ""){
            $(classCommunity).html("");

            if(classCommunity == newClassCommunity){
                classCommunity = "";
                return;
            }
        }

        let  csrf = $("meta[name=\"csrf\"]").attr("content");
        
        $.ajax({
            type: 'GET',
            url: '/api/v1/manage/projects',
            data: {id: id},
            "headers": {
                "X-CSRF-TOKEN": csrf
            },
            success: function(projects) {
                if(projects.length == 0){
                    console.log("VAZIO");
                    return;
                }

                classCommunity = "#projects_"+id;
                
                var projs = new Set();
                for(let index in projects){
                    if(projs.has(projects[index]["id"])){
                        continue;
                    }
                    projs.add(projects[index]["id"]);

                    $(classCommunity).append('<div class="row ui middle aligned mobile-'+projects[index]["id"]+'">'
                    +   '<div class="three wide tablet five wide mobile column">'
                    +   '<img class="ui centered circular tiny image" src="'+projects[index]["image_path"]+'">'
                    +   '</div>'
                    +   '<div class="ui middle aligned ten wide tablet eight wide mobile column">'
                    +   '<a href="/community/'+projects[index]["id"]+'">'
                    +   projects[index]["vision_name"]
                    +   '</a>'
                    +   '</div>'
                    +   '<div class="three wide column state-options mobile">'
                    +   '<button id="'+projects[index]["id"]+'" class="ui icon button change-state-mobile accept">'
                    +   '<i class="checkmark icon"></i>'
                    +   '</button>'
                    +   '<button id="'+projects[index]["id"]+'" class="ui icon button change-state-mobile remove">'
                    +   '<i class="remove icon"></i>'
                    +   '</button>'
                    +   '</div>'
                    +   '</div>');

                    $('.change-state-mobile.accept').click(function(e){
                        console.log("A");
                        let id = $(this).attr("id");
                        let key=".mobile-"+id;
                        $(key).remove();
                        updateProjectAcceptance(id);
                    });
    
                    $('.change-state-mobile.remove').click(function(e){
                        console.log("R");
                        let id = $(this).attr("id");
                        let key=".mobile-"+id;
                        $(key).remove();
                        deleteProject(id);
                    });
                }

            }
        });
    }

    getManage();
  }

  unmount() {
    super.unmount();
  }
}
