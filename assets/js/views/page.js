import MainView from './main';

export default class View extends MainView {
    mount() {
        super.mount();

        $('.community-user-follow-button').on('click', followButtonAction);

        function followButtonAction(e) {
            e.preventDefault();
            let communityId = parseInt($(this).attr("name"));
            let csrf = $("meta[name=\"csrf\"]").attr("content");
            $.ajax({
                type: 'POST',
                url: '/api/v1/user/follow_community/toggle_follow/' + communityId,
                "headers": {
                    "X-CSRF-TOKEN": csrf
                },
                success: function (data) {

                    if (data.follows) {
                        $(".community-user-follow-button[name="+data.id+"]").text("FOLLOWING");
                    } else {
                        $(".community-user-follow-button[name="+data.id+"]").text("FOLLOW");
                    }
                    $("meta[name=\"csrf\"]").attr("content", data.csrf)
                }
            })
        }
    }

    unmount() {
        super.unmount();
    }
}