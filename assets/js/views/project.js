import MainView from './main';
import moment from 'moment'

export default class View extends MainView {
    static get csrf() {
        return $("meta[name=\"csrf\"]").attr("content");
    }

    static get projectId() {
        return $('#project-id').val();
    }

    mount() {
        super.mount();
        $("#Glide").glide({
            type: "carousel"
        });
        this.initializeProjectPhase();

        let currentPostsPage = 0;

        $('#showCancelModalBtn').on('click', this.showCancelModal);
        
        $('.confirm-cancel-button').on('click', this.cancelProject.bind(this));

        $('#editProjectBtn').on('click', this.editProject.bind(this));
        //Project post logic
        $('.project-rating-div')
            .rating();
        $('.project-posts-container').accordion({
            selector: {
                trigger: '.title .left-info .header'
            },
            onOpen: View.getPostReplies
        });

        $('#project_category_id').dropdown();
        $('#project_impact').dropdown();
        $('#project_community_id').dropdown({
            apiSettings: {
                // this url parses query server side and returns filtered results
                url: '/api/v1/community/search?name={query}',
                headers: {
                    "X-CSRF-TOKEN": View.csrf
                },
            },
            saveRemoteData: true
        });
        /* =========== Project form section end ========== */

        $('#showCancelModalBtn').on('click', this.showCancelModal);
        $('.confirm-cancel-button').on('click', this.cancelProject.bind(this));

        $('#editProjectBtn').on('click', this.editProject.bind(this));
        //Project post logic
        $('.project-rating-div').rating();
        $('.project-posts-container').accordion({
            selector: {
                trigger: '.title .left-info .header'
            },
            onOpen: View.getPostReplies
        });


        /* ========== project posts section =========== */
        $('#new-project-post').hide();
        $('#anchor-to-new-project-post').on('click', View.showNewPost);
        $('#submit-new-project-post').on('click', View.addNewPost);
        $('.post-options-modal').on('click', View.showSettingsModal);
        $('.edit-project-post').on('click', View.editProjectPost);
        $('.delete-project-post').on('click', View.deleteProjectPost);
        $('#settings').click(() => {
            $('.menu.settings').toggle();
        });
        $('.anchor-to-new-reply').on('click', View.goToReplyInput);
        $('.edit-reply-post').on('click', View.editPostReply);
        $('.delete-reply-post').on('click', View.deletePostReply);

        /* Triggers loading of more posts */
        $('.load-more-posts').on('click', function (e) {
            e.preventDefault();
            View.loadPosts(++currentPostsPage)
        });
        /* ========== project posts section end =========== */

        const input = $('#project_location');
        if (input.length > 0) {
            const autocomplete = new google.maps.places.Autocomplete(input[0]);

            google.maps.event.addListener(autocomplete, 'place_changed', function () {
                input.html('');
                const place = autocomplete.getPlace();
                input.append('<p> Latitude and Longitude : ' + place.geometry.location + '</p>');
                input.append('<p> Address : ' + place.formatted_address + '</p>');
                input.append('<p> Places Name : ' + place.name + '</p>');

                const searchAddressComponents = place.address_components;
                $.each(searchAddressComponents, function () {
                    if (this.types[0] === "postal_code") {
                        searchCountry = this.short_name;
                    }
                });
            });
        }

        //info project
        let currentFund = $('#project-pledged-value').text();
        let goalFund = $('#project-goal-value').text();
        let percentage = 100 * currentFund / goalFund;
        $('#progress').progress({
            percent: percentage
        });

        const projectInfoButtons = $('#project-info button');

        projectInfoButtons.on('click', (e) => {
            const index = projectInfoButtons.index($(e.target));
            projectInfoButtons.removeClass('active');
            $(e.target).addClass('active');

            $('.project-info-text div').hide();
            $('.project-info-text div:nth-child(' + (index + 1) + ')').show();
        });

        $('#calendar').calendar({
            monthFirst: true,
            formatter: {
                date: function (date) {
                    if (!date) return '';
                    let day = date.getDate();
                    let month = date.getMonth() + 1;
                    if(date.getDate().toString().length == 1){
                        day = "0" + date.getDate()
                    }else{
                        day = date.getDate();
                    }
                    if(date.getMonth().toString().length == 1){
                        month = "0" + (date.getMonth() + 1);
                    }else{
                        month = date.getMonth() + 1;
                    }
                    let year = date.getFullYear();
                    return year + '-' + month + '-' + day;
                }
            },
            type: 'date'
        });

        $(".show-investors").click(function () {
            
            const lastBackerId = $("div.middle:last-child > input").val();

            $(".show-investors").addClass("loading");

            $.ajax({
                type: "GET",
                headers: {
                    "X-CSRF-TOKEN": View.csrf
                },
                url: '/api/v1/project/backers',
                data: {
                    lastBackerId: lastBackerId,
                    projectId: View.projectId
                },
                success: function (data) {
                    if(!lastBackerId) {
                        $("#backers-list").empty();
                    }

                    $("#investors").modal('show');
                    $(".show-investors").removeClass("loading");

                    if(!data.length) {
                        $("#backers-list").append(
                            "<div class='row ui middle aligned investor'>" +
                            "<input type='hidden' value='' class='investor-id'>" +
                            "<div class='one wide tablet two wide computer four wide mobile column'>" +
                            "</div>" +
                            "<div class='ui middle aligned eight wide column'>" +
                            "        <div class='investor-name'>" +
                            "This project has no backers yet"+
                            "    </div>" +
                            "</div>" +
                            "</div>"
                        );
                       return;
                    }

                    for(let user of data) {
                        if(user.id === -1){
                            $("#backers-list").append(
                                "<div class='row ui middle aligned investor'>" +
                                "<input type='hidden' value='' class='investor-id'>" +
                                "<div class='one wide tablet two wide computer four wide mobile column'>" +
                                "    <img class='ui centered circular tiny image' src='/images/default.jpeg'>" +
                                "</div>" +
                                "<div class='ui middle aligned eight wide column'>" +
                                "        <div class='investor-name'>" +
                                "Anonymous"+
                                "    </div>" +
                                "    <div class='date'>" +
                                "    Donated " + user.value + "$ " + moment(user.date, "X").fromNow() +
                                "    </div>" +
                                "</div>" +
                                "</div>"
                            );
                        }else{
                            if(user.photo === null)
                                user.photo = "/images/default.jpeg"

                            $("#backers-list").append(
                                "<div class='row ui middle aligned investor'>" +
                                "<input type='hidden' value='" + user.data_id + "' class='investor-id'>" +
                                "<div class='one wide tablet two wide computer four wide mobile column'>" +
                                "    <img class='ui centered circular tiny image' src='" + user.photo + "'>" +
                                "</div>" +
                                "<div class='ui middle aligned eight wide column'>" +
                                "        <div class='investor-name'>" +
                                 user.name +
                                "    </div>" +
                                "    <div class='date'>" +
                                "    Donated " + user.value + "$ " + moment(user.date, "X").fromNow() +
                                "    </div>" +
                                "</div>" +
                                "</div>");
                        }
                        
                        
                    }
                }
            });

        });

        this.manageImages();

        $('.click-rate > a > i').click(function () {
            let clicked = $(this).attr('id');
            let rate;

            if (clicked.indexOf("upvote") !== -1)
                rate = 1;
            else if (clicked.indexOf("downvote") !== -1)
                rate = -1;

            View.sendProjectRate(rate);
        });

        View.initStripe();
        $('#stripe-connect-btn').on('click', View.connectToStripe);
        $('#donation-amount').on('change', View.validateDonationAmount);
        $('#disconnect-stripe-acc').on('click', View.disconnectAccount);
    }

    unmount() {
        super.unmount();
    }

    /**
     * Triggers an API call that fetches 10 more posts, or as many as can be loaded from the DB
     * @param {*} page
     */
    static loadPosts(page) {
        $.ajax({
            type: "GET",
            headers: {
                "X-CSRF-TOKEN": View.csrf
            },
            url: '/api/v1/project_post/get_page',
            data: {
                project_id: View.projectId,
                page: page
            },

            /*
             * Data is a JSON object that contains an array of posts with the following info:
             *  - Title
             *  - Creator User Name
             *  - Date of Posting
             *  - Id of Poster
             *  - Id of Post
             */
            success: function (data) {

                // No more posts can be loaded from the DB, remove the option to do so
                if (data.posts.length < 10)
                    $('.load-more-posts').hide();

                data.posts.forEach(function (post) {
                    let id = post.post_id;
                    let date = post.date;
                    let title = post.title;
                    let userName = post.user_name;
                    let userId = post.user_id;
                    let userIsCreator = post.is_creator;

                    let postElement = $(
                        '<div class="item title" post-id="' + id + '">' +
                        '<div class="right floated content post-right-content">' +
                        (userIsCreator ?
                            '<div class="ui three column grid">' +
                            '<div class="column community-post-options-modal" data-post-id="' + id + '">' +
                            '<i class="setting icon"></i>' +
                            '</div>' +
                            '</div>' :
                            '') +
                        '</div>' +
                        '<i class="middle aligned icon">' +
                        '<img width="30px" height="30px" src="/images/default-user.png">' +
                        '</i>' +
                        '<div class="content left-info">' +
                        '<a class="header">' + title + '</a>' +
                        '<div class="description post-content-user">' +
                        '<a href="/user/' + userId + '">' + userName + '</a> created ' + moment(date).fromNow() +
                        '</div>' +
                        '<div class="ui grid mobile-div">' +
                        (userIsCreator ?
                            '<div class="left floated fixe wide column community-post-option-modal" post-id="' + id + '">' +
                            '<i class="setting icon"></i>' +
                            '</div>' :
                            '') +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="content"></div>'
                    );

                    $('.project-posts-container').append(postElement);
                });
            }
        });
    }

    static getPostReplies() {
        let postId = $(".item.active").attr("post-id");
        let userId = $('input[name=user-id]').val();

        let numChildren = $('.content.active').children().length;

        // verifying if the request was already made
        if (numChildren === 0) {
            $.ajax({
                type: 'GET',
                url: '/api/v1/post/' + postId,
                headers: {
                    "X-CSRF-TOKEN": View.csrf
                },
                success: function (post) {
                    const contentActive = $('.content.active');
                    contentActive.prepend('<p class="project-post-content">' + post.content + '</p>');
                    contentActive.append('<div class="ui relaxed divided list post-replies-container"></div>');
                    contentActive.append('<div class="ui grid add-post-reply">' +
                        '<div class="three wide right aligned column">' +
                        '<img width="30px" height="30px" src="/images/default-user.png ">' +
                        '</div>' +
                        '<div class="ten wide column ui input remove-border">' +
                        '<input id="input-reply-post-' + postId + '" class="input-size reply-content" placeholder="Comment Something!" type="text">' +
                        '</div>' +
                        '<div class="three wide column">' +
                        '<button data-post-id=' + postId + ' class="ui centered button comment-button submit-post-reply" type="submit">Comment</button>' +
                        '</div>' +
                        '</div>');

                    // Click on button to post reply
                    $('.submit-post-reply').on('click', View.addPostReply);
                    // Or press enter do post a reply
                    $('.reply-content').keypress(function (event) {
                        const keycode = (event.keyCode ? event.keyCode : event.which);
                        if (keycode === 13) {
                            $(this).parent().next().children().trigger('click');
                        }
                    });
                }
            });

            $.ajax({
                type: 'GET',
                url: '/api/v1/post/replies/' + postId,
                headers: {
                    "X-CSRF-TOKEN": View.csrf
                },
                success: function (replies) {

                    $('#input-reply-post-' + postId).focus();

                    if (replies.length === 0)
                        return;

                    for (let index in replies) {
                        let computerOption = '';
                        let mobileOption = '';

                        // If with three equals wasn't working and I converting to int wasn't working
                        if (parseInt(replies[index]["user_id"]) == userId) {
                            computerOption = '<div reply-id="' + replies[index]["post_reply_id"] + '" class="ui right floated grid content post-right-content community-reply-post-options-modal">' +
                                '<i class="setting icon"></i>' +
                                '</div>';
                            mobileOption = '<div class="mobile-div">' +
                                '<div class="community-reply-post-options-modal" reply-id="' + replies[index]["post_reply_id"] + '">' +
                                '<i class="setting icon"></i>' +
                                '</div>' +
                                '</div>';
                        }

                        $('.content.active div.post-replies-container')
                            .append('<div post-reply-id="' + replies[index]['post_reply_id'] + '" class="item title">' +
                                computerOption +
                                '<i class="top aligned icon">' +
                                '<img width="30px" height="30px" src="/images/default-user.png ">' +
                                '</i>' +
                                '<div class="content">' +
                                '<p reply-id="' + replies[index]["post_reply_id"] + '" class="reply-content">' + replies[index]["post_reply_content"] + '</p>' +
                                '<div class="description reply-content-user">' +
                                '<a href="/user/' + replies[index]["user_id"] + '">' + replies[index]["user_name"] + '</a>' +
                                ' created 10 min ago</div>' +
                                mobileOption +
                                '</div>' +
                                '</div>');
                        $('.community-reply-post-options-modal').on('click', View.showReplySettingsModal);
                    }
                }
            });
        }
    }

    static showNewPost() {
        let newPost = $('#new-project-post');

        if (newPost.is(':visible'))
            newPost.hide();
        else
            newPost.show();
    }

    static showSettingsModal() {
        let postId = this.dataset.postId;
        $('#settings-modal')
            .modal('show');
        $.ajax({
            type: 'GET',
            url: '/api/v1/post/' + postId,
            "headers": {
                "X-CSRF-TOKEN": View.csrf
            },
            success: function (post) {
                $('#settings-modal').attr("post-id", post.id);
                $('#settings-modal input.project-post-content').val(post.content);
                $('#settings-modal input.project-post-title').val(post.title);
            }
        });
    }

    static addNewPost() {
        let postTitle = $('input[name=post-title]').val();
        let postContent = $('textarea[name=post-content]').val();
        let userId = $('input[name=user-id]').val();

        let postTitleRequired = $('#post-title-required');
        if (postTitle.length <= 0) {
            postTitleRequired.show();
        } else if (postTitleRequired.is(':visible')) {
            postTitleRequired.hide()
        }

        let postContentRequired = $('#post-content-required');
        if (postContent.length <= 0) {
            postContentRequired.show();
        } else if (postContentRequired.is(':visible')) {
            postContentRequired.hide()
        }

        $.ajax({
            type: 'POST',
            headers: {
                "X-CSRF-TOKEN": View.csrf
            },
            url: '/api/v1/project_post/new',
            data: {
                post_title: postTitle,
                post_content: postContent,
                user_id: userId,
                project_id: View.projectId
            },
            success: function (post) {
                location.reload();
            }
        });

    }

    static editProjectPost() {

        let postId = $('#settings-modal').attr("post-id");

        if (!postId.length) {
            return;
        }

        let postTitle = $('#settings-modal input.project-post-title:visible').val();
        let postContent = $('#settings-modal input.project-post-content:visible').val();

        $.ajax({
            type: 'PUT',
            url: '/api/v1/project_post/edit/' + postId,
            data: {
                post_title: postTitle,
                post_content: postContent
            },
            headers: {
                "X-CSRF-TOKEN": View.csrf
            },
            success: function (post) {
                // TODO adding flush
                location.reload();
            }
        });
    }

    static deleteProjectPost() {
        let postId = $('#settings-modal').attr("post-id");

        if (!postId.length) {
            return;
        }

        $.ajax({
            type: 'DELETE',
            url: '/api/v1/project_post/delete/' + postId,
            headers: {
                "X-CSRF-TOKEN": View.csrf
            },
            success: function (post) {
                // TODO adding flush
                location.reload();
            }
        });
    }

    static sendProjectRate(rate) {
        $.ajax({
            type: 'POST',
            url: '/api/v1/vote/project/' + View.projectId + '/rate/' + rate,
            headers: {
                "X-CSRF-TOKEN": View.csrf
            },
            success: function (data) {
                switch (data.vote) {
                    case 1:
                        View.toggleRate(1);
                        break;
                    case 0:
                        View.toggleRate(0);
                        break;
                    case -1:
                        View.toggleRate(-1);
                        break;
                }
                View.updateProjectRate(data.project_rate);
            }
        });
    }

    static selectPhase(phase) {
        $('.project-phase.selected').removeClass('selected');
        let phaseDiv = $('.project-phase.phase-' + phase);
        phaseDiv.addClass('selected');
        phaseDiv.find('.radio').checkbox('check');
    }

    toggleEditMode() {
        let icon = $('#edit');
        $('.project-phase span').toggle('fast');
        $('.project-phase .radio').toggle('fast');
        $(icon).toggleClass('write window close');
        $('#save').toggle('fast');

        View.selectPhase(this.currentPhase);
    }

    onRadioChecked(radio) {
        this.newPhase = $(radio).find('input').val();
        View.selectPhase(this.newPhase);
    }

    saveProjectState() {
        this.currentPhase = this.newPhase;

        const settings = {
            url: this.baseUrl + "/api/v1/project/" + View.projectId + "/state/" + this.newPhase,
            method: "PUT",
            headers: {
                "X-CSRF-TOKEN": View.csrf
            }
        };

        $.ajax(settings).done(function (response) {
            // TODO: Put_flash
        });

        this.toggleEditMode();
    }

    initializeProjectPhase() {
        let radioButtons = $('.project-phase .radio');
        let currentPhase = $("#project-current-state").text();
        $(".project-phase.phase-" + currentPhase).addClass("selected");

        let selectedRadio = $('.project-phase.selected input');
        this.currentPhase = selectedRadio.val();

        /* This function is needed in order to pass to onRadioChecked the radio button that triggered the event. */
        let self = this;
        radioButtons.each((index) => {
            let thisRadioButton = $(radioButtons[index]);
            thisRadioButton.checkbox({
                onChecked: this.onRadioChecked.bind(self, thisRadioButton)
            });
        });

        $('#edit').on('click', this.toggleEditMode.bind(this));
        $('#save').on('click', this.saveProjectState.bind(this));
    }

    manageImages() {
        let numImages = 1;

        $('.add-image').click(function () {
            if (numImages < 4) {
                numImages++;
                let htmlFinal = '<div id="image_' + numImages + '" class="form-group field images">';
                let htmlInputFile = '<div id="p' + numImages + '" class="ui two column grid image_input container"><input class="form-control" id="project_project_picture_' + numImages + '" name="project[project_picture_' + numImages + ']" type="file">';
                if (numImages === 4) {
                    htmlInputFile += '<div class="ui pointing red basic label">Max 4</div>';
                }
                let htmlClose = '</div><label class="error-info"></label></div>';
                htmlFinal += htmlInputFile + htmlClose;

                let idImage = "#image_" + (numImages - 1);
                $(htmlFinal).insertAfter(idImage);
            }
        });

        $(".remove-image").click(function () {
            if (numImages > 1) {
                $("#image_" + numImages).remove();
                numImages--;
            }
        });
    }


    static toggleRate(rate) {
        const upvote = $('#upvote');
        const downvote = $('#downvote');

        let selected;

        if (upvote.hasClass('outline') && !downvote.hasClass('outline'))
            selected = downvote;
        else if (downvote.hasClass('outline') && !upvote.hasClass('outline'))
            selected = upvote;

        switch (rate) {
            case 1:
                if (selected != null)
                    View.toggleRate(0);
                upvote.transition({
                    animation: 'scale',
                    duration: '300ms',
                    onComplete: function () {
                        upvote.removeClass('outline');
                        upvote.transition('scale');
                    }
                });
                break;
            case 0:
                selected.transition({
                    animation: 'scale',
                    duration: '300ms',
                    onComplete: function () {
                        selected.addClass('outline');
                        selected.transition('scale');
                    }
                });
                break;
            case -1:
                if (selected != null)
                    View.toggleRate(0);
                downvote.transition({
                    animation: 'scale',
                    duration: '300ms',
                    onComplete: function () {
                        downvote.removeClass('outline');
                        downvote.transition('scale');
                    }
                });
                break;
            default:
        }
    }

    static updateProjectRate(rate) {
        const karma = $('#karma span');
        const currentRate = karma[0].innerHTML;

        if (currentRate > rate) {
            karma.transition({
                animation: 'slide down',
                duration: '300ms',
                onComplete: () => {
                    karma.html(rate);
                    karma.transition('slide down');
                }
            });
        } else if (currentRate < rate) {
            karma.transition({
                animation: 'slide up',
                duration: '300ms',
                onComplete: () => {
                    karma.html(rate);
                    karma.transition('slide up');
                }
            });
        }
    }


    cancelProject() {
        const settings = {
            "url": this.baseUrl + "/api/v1/project/" + View.projectId + "/deleted/true",
            "method": "PUT",
            "headers": {
                "X-CSRF-TOKEN": View.csrf
            }
        };

        $.ajax(settings).done(() => {
            location.href = window.location.protocol + "//" + window.location.host
        });
    }

    editProject() {
        window.location = window.location.protocol + "//" + window.location.host + "/project/" + View.projectId + "/edit"
    }

    showCancelModal() {
        $('#cancel-modal').modal('show');
    }

    openInvestorsModel() {
        $("#investors").modal('show');
    }

    static connectToStripe(event) {
        // Do not redirect yet, first we have to store the donation intent in the database
        event.preventDefault();

        $.ajax(this.dataset.stripeAjaxUrl, {
            method: 'PUT',
            headers: {
                "X-CSRF-TOKEN": View.csrf
            }
        }).done(() => {
            alert('Wait a little. You will be redirected to Stripe\'s website shortly...')
            window.location.href = this.href;
        }).fail(() => {
            alert('Error connecting with Stripe');
        });
    }

    static validateDonationAmount() {
        const regex = /(?=.)^\$?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+)?(\.[0-9]{1,2})?$/;

        if (regex.test($(this).val())) {
            $(this).parent().removeClass('error');
        } else {
            $(this).parent().addClass('error');
        }
    }

    static getDonationAmount() {
        const amount = $('#amount').val();
        return Math.floor(100 * Number.parseFloat(amount))
    }

    static initStripe() {
        const handler = StripeCheckout.configure({
            key: 'pk_test_LX7Y8xx1DKSdEzlSz9kFrzf1',
            image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
            locale: 'auto',
            token: function (token) {
                $.ajax('/api/v1/project/donation', {
                        method: 'POST',
                        data: {
                            token: token,
                            amount: View.getDonationAmount(),
                            currency: 'usd',
                            'project_id': View.projectId
                        },
                        headers: {
                            'X-CSRF-TOKEN': View.csrf
                        }
                    })
                    .then(() => {})
                    .catch(() => {});
            }
        });

        $('#donate-button').on('click', (e) => {
            const amount = $('#amount').val();
            if (!amount.match(/(?=.)^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+)?(\.[0-9]{1,2})?$/)) {
                $('#donate-form').addClass('error');
                return false;
            }

            handler.open({
                name: 'Co-Creative Universe',
                description: 'Donation',
                zipCode: false,
                currency: 'usd',
                amount: Math.floor(100 * Number.parseFloat(amount)),
                bitcoin: true,
                image: '/images/logo_background.png'
            });
            e.preventDefault();
        });

        // Close Checkout on page navigation:
        window.addEventListener('popstate', function () {
            handler.close();
        });
    }

    static disconnectAccount(e) {
        $.ajax('/project/disconnect/' + View.projectId, {
            method: 'post',
            headers: {
                'X-CSRF-TOKEN': View.csrf
            }
        }).then(() => {
            location.reload();
        });

        e.preventDefault();
    }

    static addPostReply() {
        let postId = $(this).data("post-id");
        let userId = $('input[name=user-id]').val();
        let inputElement = $(this).parent().prev().children();

        // No empty replies
        if (inputElement.val().length === 0) {
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/api/v1/post_reply/new',
            headers: {
                "X-CSRF-TOKEN": document.querySelector("meta[name=csrf]").content
            },
            data: {
                post_id: postId,
                user_id: userId,
                content: inputElement.val()
            },
            success: (postReply) => {
                inputElement.val("");
                $('.content.active div.post-replies-container')
                    .append('<div post-reply-id="' + postReply['id'] + '" class="item title">' +
                        '<div reply-id="' + postReply['id'] + '" class="ui right floated grid content post-right-content community-reply-post-options-modal">' +
                        '<i class="setting icon"></i>' +
                        '</div>' +
                        '<i class="top aligned icon">' +
                        '<img width="30px" height="30px" src="/images/default-user.png ">' +
                        '</i>' +
                        '<div class="content">' +
                        '<p reply-id="' + postReply['id'] + '" class="reply-content">' + postReply["content"] + '</p>' +
                        '<div class="description reply-content-user">' +
                        '<a href="/user/' + postReply["userId"] + '">' + postReply['username'] + '</a>' +
                        ' created 10 min ago</div>' +
                        '<div class="mobile-div">' +
                        '<div class="community-reply-post-options-modal" reply-id="' + postReply['id'] + '">' +
                        '<i class="setting icon"></i>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '</div>');
                $('.community-reply-post-options-modal').on('click', View.showReplySettingsModal);
            }
        });
    }

    static goToReplyInput() {
        $(this).parent().prev().trigger('click');
        let postId = $(this).parent().parent().parent().attr('post-id');
        $('#input-reply-post-' + postId).focus();
    }

    static showReplySettingsModal() {
        let csrf = $("meta[name=\"csrf\"]").attr("content");

        let replyId = $(this).attr("reply-id");

        $('#reply-settings-modal')
            .modal('show');
        $.ajax({
            type: 'GET',
            url: '/api/v1/post_reply/' + replyId,
            headers: {
                "X-CSRF-TOKEN": csrf
            },
            success: function (reply) {
                $('#reply-settings-modal').attr("reply-id", reply.id);
                $('#reply-settings-modal input.project-reply-post-content').val(reply.content);
            }
        });
    }

    static editPostReply() {
        let replyId = $('#reply-settings-modal').attr("reply-id");

        if (!replyId.length) {
            return;
        }

        let replyContent = $('#reply-settings-modal input.project-reply-post-content:visible').val();

        let csrf = $("meta[name=\"csrf\"]").attr("content");

        $.ajax({
            type: 'PUT',
            url: '/api/v1/post_reply/edit/' + replyId,
            data: {
                reply_content: replyContent
            },
            headers: {
                "X-CSRF-TOKEN": csrf
            },
            success: function (reply) {
                $('p[reply-id=' + replyId + ']').text(replyContent);
                $('#reply-settings-modal').modal('hide');
            }
        });
    }

    static deletePostReply() {
        let replyId = $('#reply-settings-modal').attr("reply-id");

        if (!replyId.length) {
            return;
        }

        let csrf = $("meta[name=\"csrf\"]").attr("content");

        $.ajax({
            type: 'DELETE',
            url: '/api/v1/post_reply/delete/' + replyId,
            headers: {
                "X-CSRF-TOKEN": csrf
            },
            success: function (reply) {
                $('div[post-reply-id=' + replyId + ']').remove();
                $('#reply-settings-modal').modal('hide');
            }
        });
    }

}