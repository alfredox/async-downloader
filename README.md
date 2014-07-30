ASYNC DOWNLOADER
================

This gem purpose is to make the downloading of files from the internet easier and in an async manner, and using wget.

TODOS
-----
- syntax for downloading asychronously with wget
- create a prototype function to download one file.
- establish the conditions for finishing (succesfully and with errors) the download
- establish the fields of the model:
  - file name, path, state, error, percent, etc., pid (para identificar proceso)
- Shiould use temporal files
- Create it as a gem
- make a task to run continously
- should configure the other parameters.


DESCRIPTION

  This uses a model to have control over the downloads (with state), and asyncronously download the files.
  
USAGE
-----


