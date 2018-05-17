import React from 'react';
import ReactDOM from 'react-dom';
import configureStore from './store/store';
import Root from './components/root';
//test
import {signup, login, logout} from './actions/session_actions';
import {fetchTeam, fetchTeams, createTeam, updateTeam, fetchMembers} from './actions/team_actions';
import {fetchProject, fetchProjects, createProject, updateProject, removeProject} from './actions/project_actions';

document.addEventListener('DOMContentLoaded', () => {
  const root = document.getElementById('root');
  let store;
  if (window.currentUser) {
    const preloadedState = {
      entities: {
        users: { [window.currentUser.id]: window.currentUser },
        teams: window.currentTeams,
        tasks: window.myTasks
      },
      session: { id: window.currentUser.id }
    };
    store = configureStore(preloadedState);
    delete window.currentUser;
    delete window.currentTeams;
    delete window.myTasks;
  } else {
    store = configureStore();
  }

  ReactDOM.render(
    <Root store={ store } />,
    root
  );
  //test
  window.getState = store.getState;
  window.dispatch = store.dispatch;

});

//test
window.signup = signup;
window.login = login;
window.logout = logout;
window.fetchMembers = fetchMembers;
window.fetchTeams = fetchTeams;
window.fetchTeam = fetchTeam;
window.createTeam = createTeam;
window.updateTeam = updateTeam;

window.fetchProjects = fetchProjects;
window.fetchProject = fetchProject;
window.createProject = createProject;
window.updateProject = updateProject;
window.removeProject = removeProject;
