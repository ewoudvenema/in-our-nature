defmodule CocuWeb.Router do
  use CocuWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CocuWeb.SaveLocale
  end

  pipeline :api do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Cocu.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  end

  scope "/", CocuWeb do
    pipe_through [:browser, :auth] # Use the default browser stack

    get "/explore", ExploreController, :index
    get "/manage", ManageController, :index
    get "/", PageController, :index
    resources "/community", CommunityController
    get "/project/show/:id", ProjectController, :show
    resources "/media", MediaController
    resources "/user", UserController, only: [:index, :new, :create]
    post "/user/login", UserController, :login
    resources "/pagenotfound", PageNotFoundController

  end

  scope "/api", CocuWeb do
    pipe_through [:api, :auth]

    scope "/v1", V1, as: :v1 do
      get "/post/:id", PostController, :getPostById
      post "/project/donation", ProjectController, :donate
      get "/post/replies/:id", PostController, :getPostReplies
      get "/explore", ExploreController, :getProjects
      get "/communities", CommunityController, :get_communities
      get "/manage/communities", ManageController, :getCommunities
      get "/manage/projects", ManageController, :getCommunitiesProjects
      get "/project/backers", ProjectController, :getBackers
    end
  end

  scope "/api", CocuWeb do
    pipe_through [:api, :auth, :ensure_auth]

    scope "/v1", V1, as: :v1 do
      post "/community_post/new", CommunityPostController, :addCommunityPost
      put "/community_post/edit/:id", CommunityPostController, :editCommunityPost
      delete "/community_post/delete/:id", CommunityPostController, :deleteCommunityPost
      post "/post_reply/new", PostReplyController, :addPostReply
      get "/post_reply/:id", PostReplyController, :getPostReplyById
      put "/post_reply/edit/:id", PostReplyController, :editPostReply
      delete "/post_reply/delete/:id", PostReplyController, :deletePostReply
      put "/project/:id/state/:state", ProjectController, :updateProjectState
      put "/project/:id/deleted/:deleted", ProjectController, :updateProjectDeleted
      put "/project/connect/:id", ProjectController, :connect
      put "/user/:id/deleted/:deleted", UserController, :updateUserDeleted
      post "/user/follow_community/toggle_follow/:community_id", CommunityUsersController, :toggle_follow
      get "/community/get_followers", CommunityUsersController, :get_followers
      post "/community/invite_user/", UserInviteController, :invite_user_to_community
      post "/community/remove_user", CommunityUsersController, :remove_user
      post "/vote/project/:project_id/rate/:rate", VoteController, :userRateProject
      post "/user/follow_community/accept_invitation/:community_id", CommunityUsersController, :accept_invitation
      post "/user/follow_community/reject_invitation/:community_id", CommunityUsersController, :reject_invitation
      get "/community_post/get_page/", CommunityPostController, :get_by_page
      get "/project_post/get_page", ProjectPostController, :get_by_page
      put "/project_post/edit/:id", ProjectPostController, :editProjectPost
      post "/project_post/new", ProjectPostController, :addProjectPost
      delete "/project_post/delete/:id", ProjectPostController, :deleteProjectPost
      put "/manage/updateAcceptance", ManageController, :updateProjectAcceptance
      delete "/community/delete/:id", CommunityController, :deleteCommunity
      get "/community/get_n_projects", CommunityController, :get_n_projects
      get "/community/search", CommunityUsersController, :get_available_communities
      put "/manage/deleteProject/:id", ManageController, :deleteProject
    end
  end

  #Routes that require authentication
  scope "/", CocuWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    resources "/project", ProjectController,  only: [:edit, :delete, :update, :new, :create]
    resources "/project", ProjectController, only: [:edit, :delete, :update, :new, :create]
    resources "/user", UserController, only: [:show, :edit, :delete, :update]
    get "/project/donation", ProjectController, :donate
    get "/project/donation/finished", ProjectController, :donation_finished
    get "/project/connect", ProjectController, :connect_stripe_acc
    post "/project/disconnect/:id", ProjectController, :disconnect_stripe_acc
    post "/user/logout", UserController, :logout
    post "/user/follow_community/:community_id", CommunityUserController, :follow_community
    put "/user/:id/update_password", UserController, :update_password
    put "/user/:id/update_picture", UserController, :update_picture
  end

  scope "/", CocuWeb do
    get "/*path", PageNotFoundController, :error
  end
end
