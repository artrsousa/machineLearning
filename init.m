%{
init.m 
  This function cleans up the workspace and
  includes the dataset and the needed folders
  to the environment path.

  To run the toolbox, you should execute the 
  main.m file.
%}
function init
  % Cleans up the workspace
  close all; clc; clear;
  disp('Initializing the workspace');
  % Adds the needed directories to the workspace
  addpath('dataset/banana/');
  addpath('classifiers/');
  addpath('hsifunctions/');
  addpath('helper/');
  addpath('app/');
  disp('Workspace initialized');
  