function peercompile

% PEERCOMPILE compile the low-level mex file implements that implements
% the TCP/IP, announce and discover services.

if ispc

  % FIXME do something here
  error('the compatibility with windows has not been fully implemented yet')

elseif isunix || ismac

  olddir = pwd;

  try

    % go into the directory containing the source code
    newdir = fullfile(fileparts(which(mfilename)), 'src');
    cd(newdir);

    % these are general
    mex  -I. -c tcpserver.c
    mex  -I. -c tcpsocket.c
    mex  -I. -c discover.c
    mex  -I. -c announce.c
    mex  -I. -c expire.c
    mex  -I. -c peerinit.c
    mex  -I. -c util.c
    mex  -I. -c extern.c
    mex  -I. -c fairshare.c

    % link all the objects together into a mex file
    mex -I. -output ../peer peer.c tcpserver.o tcpsocket.o discover.o announce.o expire.o peerinit.o util.o extern.o fairshare.o -lpthread

    % also compile the memory profiler
    mex -I. -output ../memprofile memprofile.c

    % return to the original directory
    cd(olddir);

  catch
    % return to the original directory
    cd(olddir);
    % report the error
    rethrow(lasterror);
  end

end

