import MainView    from './main';
import ProjectView from './project';
import CommunityView from './community';
import UserView from './user';
import ExploreView from './explore';
import ManageView from './manage';
import PageView from './page';
import Page_not_foundView from './page_not_found.js';

// Collection of specific view modules
const views = {
    ProjectView,
    CommunityView,
    UserView,
    ExploreView,
    ManageView,
    PageView,
    Page_not_foundView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
