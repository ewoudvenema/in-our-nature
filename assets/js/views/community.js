import MainView from './main';
import moment from "moment";

export default class View extends MainView {
    mount() {
        super.mount();

        let selected_categories = [];
        let selected_project_state = ['presentation', 'funding', 'creation'];
        let selected_impact = ['regional', 'national', 'international', 'global'];
        let selected_communities = [];
        let currentUsersPage = 0;
        let currentPostsPage = 0;
        let currentProjectsPage = 0;
        let currentExplorePage = 0;

        $(document).ready(() => {
            /* =========== General admin options start ========== */
            $('.community-admin-options').dropdown();
            $('#get_confirmation_delete_community').on('click', openDeleteModal);
            $('#toggle-group').on('click', setGroup);
            $('#toggle-community').on('click', setCommunity);
            $('#delete_community').on('click', deleteCommunity);

            $('.ui.rating')
                .rating();

            /* Triggers the modal that  confirms the deletion */
            function openDeleteModal() {
                $('#delete-confirmation-modal').modal('show');
            }

            /* Modal that confirms the deletion of the community */
            $('#confirmation-input-name').keyup(function () {
                if ($(this).val() == $('#span-community-name').text()) {
                    $('#delete_community').removeAttr("disabled");
                } else {
                    $('#delete_community').attr("disabled", "disabled");
                    $(this).attr("border-color", "red");
                    $(this).attr("border", "3 px");
                }
            });
            /* =========== General admin options end ========== */

            /* Triggers loading of more projects associated with the community */
            $('.load-more-projects').on('click', function (e) {
                e.preventDefault();
                loadProjects(++currentProjectsPage);
            });

            /* =========== Community Posts start ========== */
            $('#new-post').hide();
            $('#anchor-to-new-post').on('click', showNewPost);
            $('#submit-new-post').on('click', addNewPost);
            $('.community-post-options-modal').on('click', showSettingsModal);

            /* Triggers loading of more posts */
            $('.load-more-posts').on('click', function (e) {
                e.preventDefault();
                loadPosts(++currentPostsPage)
            });

            /* Triggers loading of a post's replies */
            $('#posts-container.ui.accordion').accordion({
                selector: {
                    trigger: '.title .left-info .header'
                },
                onOpen: getPostReplies
            });

            $('.edit-project-post').on('click', editProjectPost);
            $('.delete-project-post').on('click', deleteProjectPost)
            $('.edit-reply-post').on('click', editPostReply);
            $('.delete-reply-post').on('click', deletePostReply);
            $('.anchor-to-new-reply').on('click', goToReplyInput);
            /* =========== Community Posts start ========== */



            /* ========== Community users start ========== */
            $('.community-user-follow-button').on('click', followButtonAction);
            let invitationModal = $("#community-invite-user-modal");
            let invitationAccordion = $('#community-invite-user-accordion.accordion');
            invitationAccordion.accordion();
            let invitationAccordionTitleContent = invitationAccordion.find('Remove.title').children();

            /* Binding events to buttons */
            invitationModal.modal('attach events', '.community-user-count-invite-user');
            invitationModal.modal('attach events', '.invite-community-user-cancel', 'hide');

            /* Changes the title of the accordion to a chevron pointing up on open and back again on close */
            invitationAccordion.accordion({
                onOpen: function () {
                    invitationAccordionTitleContent.remove();
                    invitationAccordion.find('.title').append('<i class="icon chevron up"></i>');
                },

                onClose: function () {
                    invitationAccordion.find('.title').empty();
                    invitationAccordion.find('.title').append(invitationAccordionTitleContent);
                    invitationAccordion.find('.community-invite-status').hide();
                }
            });

            /* Triggers the invitation (modal) */
            $('#community-invite-user-modal .invite-community-user-ok').on('click',
                function (e) {
                    e.preventDefault();
                    let value = $('#community-invite-user-modal input.community-invitee-input').val();
                    inviteUser(value, invitationModal);
                }
            );

            /* Triggers the invitation (accordion) */
            $('#community-invite-user-accordion .invite-community-user-ok').on('click',
                function (e) {
                    e.preventDefault();
                    let value = $('#community-invite-user-accordion input.community-invitee-input').val();
                    inviteUser(value, invitationAccordion);
                }
            );

            /* User list modal */
            $('.community-user-count').on('click', function (e) {
                e.preventDefault();
                $('#community-user-list-modal').modal('show');
                currentUsersPage = 0;
                getFollowers(currentUsersPage++);
            });

            $('.coupled.modal').modal({
                allowMultiple: true
            });

            /* User removal */
            $('.remove-user-confirm').on('click', function (e) {
                e.preventDefault();
                let userId = $(this).parent('.actions').find('.meta-user-id').text();
                userId = parseInt(userId);
                removeUserAction(userId);
                $('.community-user-list .item.selected').remove();
                $(this).parents('.modal').modal('hide');
            })
            /* ========== Community users end ========== */

            $('.next-page').on('click', function (e) {
                e.preventDefault();
                let communityName = $('#searchCommunityName').val();
                let order = $("#orderby").find("option:selected").attr('value');
                getCommunities(communityName, order, ++currentExplorePage);
            });

            $('.prev-page').on('click', function (e) {
                e.preventDefault();
                let communityName = $('#searchCommunityName').val();
                let order = $("#orderby").find("option:selected").attr('value');
                getCommunities(communityName, order, --currentExplorePage);
            });
        });

        function setGroup(e) {
            e.preventDefault();
        }

        function setCommunity(e) {
            e.preventDefault();
        }

        function followButtonAction(e) {
            e.preventDefault();
            let communityId = parseInt($("#community-id").text());
            let csrf = $("meta[name=\"csrf\"]").attr("content");
            $.ajax({
                type: 'POST',
                url: '/api/v1/user/follow_community/toggle_follow/' + communityId,
                "headers": {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (data) {

                    if (data.follows) {
                        $("#follow-button").text("Following")
                    } else {
                        $("#follow-button").text("Follow")
                    }
                    $("meta[name=\"csrf\"]").attr("content", data.csrf)
                }
            })
        }

        /**
         * Triggers an API call that fetches 4 more project, 
         * or as many as can be loaded from the DB
         * @param {*} page 
         */
        function loadProjects(page) {
            let csrf = $("meta[name=\"csrf\"]").attr("content");
            let communityId = parseInt($("#community-id").text());

            $.ajax({
                type: "GET",
                headers: {
                    "X-CSRF-TOKEN": csrf
                },
                url: "/api/v1/community/get_n_projects",
                data: {
                    community_id: communityId,
                    page: page
                },
                /*
                 * data is a JSON object that contains the following:
                 *  - Project ID
                 *  - Project Name
                 *  - Project Picture (or a default image, if no image is set)
                 */
                success: function (data) {
                    // If no more projects can be loaded
                    if (data.projects.length < 4)
                        $('.load-more-projects').hide();

                    data.projects.forEach(function (project) {
                        let projectId = project.project_id;
                        let projectName = project.vision_name;
                        let projectImage = project.image_path;

                        let projectElement = $(
                            '<div class="column">' +
                            '<a href="/project/show/' + projectId + '">' +
                            '<div class="ui grid project-div-container">' +
                            '<div class="zoom-effect-container">' +
                            '<div class="row image-card">' +
                            '<img class="ui rounded image project-image" width="280px" height="200px" src="' + projectImage + '">' +
                            '</div>' +
                            '</div>' +
                            '<div class="row project-div-name">' +
                            '<span class="project-name">' + projectName + '</span>' +
                            '</div></div></a></div>'
                        );

                        $('#project-list-container').append(projectElement);
                    });
                }
            })
        }

        function showNewPost(e) {
            let newPost = $('#new-post');

            if (newPost.is(':visible'))
                newPost.hide();
            else
                newPost.show();
        }

        function addNewPost(e) {
            let postTitle = $('input[name=post-title]').val();
            let postContent = $('textarea[name=post-content]').val();
            let userId = $('input[name=user-id]').val();
            let communityId = $('input[name=community-id]').val();

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
                    "X-CSRF-TOKEN": document.querySelector("meta[name=csrf]").content
                },
                url: '/api/v1/community_post/new',
                data: {
                    post_title: postTitle,
                    post_content: postContent,
                    user_id: userId,
                    community_id: communityId
                },
                success: function (post) {
                    location.reload();
                }
            });
        }

        function showSettingsModal() {

            let csrf = $("meta[name=\"csrf\"]").attr("content");

            let postId = this.dataset.postId;

            $('#settings-modal')
                .modal('show');
            $.ajax({
                type: 'GET',
                url: '/api/v1/post/' + this.dataset.postId,
                "headers": {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (post) {
                    $('#settings-modal').attr("post-id", post.id);
                    $('#settings-modal input.project-post-content').val(post.content);
                    $('#settings-modal input.project-post-title').val(post.title);
                }
            });
        }

        /**
         * Triggers an API call that fetches 10 more posts, or as many as can be loaded from the DB
         * @param {*} page 
         */
        function loadPosts(page) {
            let csrf = $("meta[name=\"csrf\"]").attr("content");
            let communityId = parseInt($("#community-id").text());

            $.ajax({
                type: 'GET',
                url: '/api/v1/community_post/get_page',
                data: {
                    community_id: communityId,
                    page: page
                },
                headers: {
                    "X-CSRF-TOKEN": csrf
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

                        $('#posts-container').append(postElement);
                    });
                }
            })
        }

        function editProjectPost() {

            let postId = $('#settings-modal').attr("post-id");

            if (!postId.length) {
                return;
            }

            let postTitle = $('#settings-modal input.project-post-title:visible').val();
            let postContent = $('#settings-modal input.project-post-content:visible').val();

            let csrf = $("meta[name=\"csrf\"]").attr("content");

            $.ajax({
                type: 'PUT',
                url: '/api/v1/community_post/edit/' + postId,
                data: {
                    post_title: postTitle,
                    post_content: postContent
                },
                headers: {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (post) {
                    // TODO adding flush
                    location.reload();
                }
            });
        }

        function deleteProjectPost() {
            let postId = $('#settings-modal').attr("post-id");

            if (!postId.length) {
                return;
            }

            let csrf = $("meta[name=\"csrf\"]").attr("content");

            $.ajax({
                type: 'DELETE',
                url: '/api/v1/community_post/delete/' + postId,
                headers: {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (post) {
                    // TODO adding flush
                    location.reload();
                }
            });
        }

        function deleteCommunity() {
            let csrf = $("meta[name=\"csrf\"]").attr("content");
            let communityId = parseInt($("#community-id").text());
            
            $.ajax({
                type: 'DELETE',
                url: '/api/v1/community/delete/' + communityId,
                headers: {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (post) {
                    // TODO adding flush
                    location.href = "/";
                }
            });
        }

        /*
         * Creates a POST request with the invitee email and community ID
         * The controller fetches the invitee's if from the email and 
         * creates an entry on the relevant table in the DB
         */
        function inviteUser(userInfo, invokingElement) {
            let communityId = parseInt($("#community-id").text());
            $.ajax({
                type: 'POST',
                headers: {
                    "X-CSRF-TOKEN": document.querySelector("meta[name=csrf]").content
                },
                url: '/api/v1/community/invite_user/',
                data: {
                    community_id: communityId,
                    invitee_info: userInfo
                },

                /* data is a JSON object with a status message */
                success: function (data) {
                    if (data.status == "ok") {
                        invokingElement.find('.failure').hide();
                        invokingElement.find('.success').show();
                    } else {
                        if (data.status == "error")
                            data.status = "An invite to this community was already sent for this user"
                        invokingElement.find('.success').hide();
                        invokingElement.find('.failure').text(data.status).show();
                    }
                }
            });
        }

        /**
         * Returns an array of n users (default 10)
         * that follow a community identified by its id
         * 
         * @param {*} communityId 
         * @param {*} n 
         * @param {*} page 
         */
        function getFollowers(page) {
            let communityId = parseInt($("#community-id").text());
            $("#community-user-list-modal .loader-segment").show();
            $.ajax({
                type: 'GET',
                headers: {
                    "X-CSRF-TOKEN": document.querySelector("meta[name=csrf]").content
                },
                url: '/api/v1/community/get_followers/',
                data: {
                    community_id: communityId,
                    page: page
                },

                /* 
                 * data is a json object with an element users that is an array of user objects
                 * that contain the user id, name and photo
                 * also a flag to signal if the user is the community founder
                 */
                success: function (data) {

                    if (page == 0)
                        $('.community-user-list .item-user').remove();

                    /* No more users to display */
                    if (data.users.length == 0 || data.users.length < 10)
                        currentUsersPage = -5;

                    /* Hide the loader */
                    $("#community-user-list-modal .loader-segment").hide();

                    /* Display the users */
                    data.users.forEach(user => {
                        $("#community-user-list-modal .loader-segment").before(
                            '<div class="item item-user">' +
                            '<a class="ui tiny circular image" href="/user/' + user.id + '">' +
                            '<img class="" alt="user image" src="' + user.photo + '">' +
                            '</a>' +
                            '<div class="content">' +
                            '<a class="header" href="/user/' + user.id + '">' + user.name + '</a>' +
                            (data.is_founder ? '<div class="description user-list-remove-user"><i class=" icon remove user"></i>Remove this user</div>' : '') +
                            '</div>' +
                            '<div class="meta"><span class="meta-user-id">' + user.id + '</span></div>' +
                            '</div>'
                        )
                    });

                    $('#community-remove-user-modal').modal('attach events', '.user-list-remove-user');

                    /*
                     * Trigger user removal modal when the corresponding option is selected
                     */
                    $('.user-list-remove-user').on('click', function (e) {
                        e.preventDefault();
                        let userId = $(this).parents('.item').find('.meta .meta-user-id').text();
                        $('#community-remove-user-modal').find('.meta-user-id').text(userId);
                        $(this).parents('.item').addClass('selected')
                    });

                    $(".follower-trigger").removeClass("follower-trigger");
                    /* Trigger the loading of more users when the last user is visible */
                    $('.community-user-list .item:last').visibility({
                        onTopVisible: triggerGetFollowers(currentUsersPage++)
                    }).addClass("follower-trigger");
                }
            });
        }

        /**
         * Called when the last element of the users list is visible.
         * Loads more users
         * @param {*} page 
         */
        function triggerGetFollowers(page) {
            if (page <= 0)
                currentUsersPage = -1;
            else
                getFollowers(page);
        }

        /**
         * Invokes an API action that removes a user identified by its ID from a community
         * @param {*} userId 
         */
        function removeUserAction(userId) {
            let communityId = parseInt($("#community-id").text());

            $.ajax({
                type: 'POST',
                headers: {
                    "X-CSRF-TOKEN": document.querySelector("meta[name=csrf]").content
                },
                url: '/api/v1/community/remove_user',
                data: {
                    community_id: communityId,
                    user_id: userId
                },
                /*
                 * Success is a simple JSON object with a status message within
                 * status: "success" or status:"error"
                 */
                success: function (data) {}
            })
        }

        $("#searchCommunityName").keypress(function (e) {
            let key = e.which;

            if (key == 13) {
                let communityName = $(this).val();
                let order = $("#orderby").find("option:selected").attr('value');
                currentExplorePage = 0;
                getCommunities(communityName, order, currentExplorePage);
            }

        });

        $("#searchBtn").click(function (e) {
            let communityName = $('#searchCommunityName').val();
            let order = $("#orderby").find("option:selected").attr('value');
            getCommunities(communityName, order, 0);
        });

        $('#orderby').change(function () {
            let communityName = $('#searchCommunityName').val();
            let order = $("#orderby").find("option:selected").attr('value');
            currentExplorePage = 0;
            getCommunities(communityName, order, currentExplorePage);
        });

        function getCommunities(name, order, page) {

            let csrf = $("meta[name=\"csrf\"]").attr("content");
            name = "%" + name + "%";
            order = order;

            $.ajax({
                type: 'GET',
                url: '/api/v1/communities',
                data: {
                    name: name,
                    order: order,
                    page: page
                },
                "headers": {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (communities) {

                    if (communities.length == 0) {
                        $('.next-page').addClass("disabled");
                        return;
                    } else if (communities.length < 12)
                        $('.next-page').addClass("disabled");
                    else
                        $('.next-page').removeClass("disabled")

                    $(".ui.grid.stackable.community .unique-community").remove();

                    for (let index in communities) {
                        if (communities[index]["picture_path"] == null)
                            var image = '/images/default-project-image.png';
                        else {
                            var image = communities[index]["picture_path"];
                            image = image.trim().replace(/ /g, '%20');
                        }

                        if (image == "") {
                            image = '/images/universe_mask.jpg';
                        }

                        let rel = "'/community/" + communities[index]["id"] + "'";

                        $(".ui.grid.stackable.community #pagination").before('<div class="four wide column unique-community" onclick="window.location.href=' + rel + '"><div class="ui fluid image community-image">' +
                            '<img class="ui centered image " src=' + image + '>' +
                            '<div class="ui ribbon label">' + communities[index]["name"] + '</div></div>' +
                            '<div class="community-title">' + communities[index]["name"] + '</div>' +
                            '<div class="community-description">' + communities[index]["description"] + '</div>' +
                            '<hr>' +
                            '<div class="community-founder">Created by: ' + communities[index]["founder_name"] + '</div>' +
                            '</div></div></div>' +
                            '</div>');
                    }
                }
            });

            if (currentExplorePage == 0)
                $('.prev-page').addClass("disabled");
            else
                $('.prev-page').removeClass("disabled")
        }

        getCommunities("", "", 0);

        function addPostReply() {
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
                    $('.community-reply-post-options-modal').on('click', showReplySettingsModal);
                }
            });
        }

        function getPostReplies() {
            let postId = $(".item.active").attr("post-id");
            let userId = $('input[name=user-id]').val();

            let numChildren = $('.content.active').children().length;

            // verifying if the request was already made
            if (numChildren === 0) {
                $.ajax({
                    type: 'GET',
                    url: '/api/v1/post/' + postId,
                    headers: {
                        "X-CSRF-TOKEN": document.querySelector("meta[name=csrf]").content
                    },
                    success: function (post) {
                        $('.content.active').prepend('<p class="post-content">' + post.content + '</p>');
                        $('.content.active').append('<div class="ui relaxed divided list post-replies-container"></div>');
                        $('.content.active').append('<div class="ui grid add-post-reply">' +
                            '<div class="three wide right aligned column">' +
                            '<img width="30px" height="30px" src="/images/default-user.png ">' +
                            '</div>' +
                            '<div class="ten wide column ui input remove-border">' +
                            '<input id="input-reply-post-' + postId + '" class="input-size reply-content" placeholder="Comment Something!" type="text">' +
                            '</div>' +
                            '<div class="three wide column">' +
                            '<button id="submit-reply' + postId + '" data-post-id=' + postId + ' class="ui centered button comment-button submit-post-reply" type="submit">Comment</button>' +
                            '</div>' +
                            '</div>');

                        // Click on button to post reply   
                        $('.submit-post-reply').on('click', addPostReply);
                        // Or press enter do post a reply
                        $('.reply-content').keypress(function (event) {
                            var keycode = (event.keyCode ? event.keyCode : event.which);
                            if (keycode == '13') {
                                $(this).parent().next().children().trigger('click');
                            }
                        });
                    }
                });

                $.ajax({
                    type: 'GET',
                    url: '/api/v1/post/replies/' + postId,
                    headers: {
                        "X-CSRF-TOKEN": this.csrf
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
                        }
                        $('.community-reply-post-options-modal').on('click', showReplySettingsModal);
                    }
                });
            }
        }

        function goToReplyInput() {
            $(this).parent().prev().trigger('click');
            let postId = $(this).parent().parent().parent().attr('post-id');
            $('#input-reply-post-' + postId).focus();
        }

        function showReplySettingsModal() {
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

        function editPostReply() {
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

        function deletePostReply() {
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

    unmount() {
        super.unmount();
    }
}