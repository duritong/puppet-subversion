The subversion module provides a ``subversion`` class and a
``working-copy`` definition. It has only been tested on Debian Etch.

**subversion** (*class*)
  Installs the ``subversion`` package. On Debian systems and its derivats 
  the ``subversion-tools`` package is installed as well.

  Example::

    node svn.example.internal {
      include subversion
    }

**subversion::xmlstarlet** (*class*)
  Installs the ``xmlstarlet`` package, which is required for the ``working-copy``
  definition.


**subversion::basics** (*class*)
  Some basic directory setups for a server, which might get used on ``subversion::svnrepo``


**subversion::working-copy** (*definition*)
  Checks out a copy of the named subversion project into the specified
  directory. Keeps the working copy in sync with the repository. The
  URL that is used to check out the working copy is constructed from
  the provided parameters like so:
  ``svn+ssh://$repo_base/$name/trunk`` or, if a branch is specified,
  ``svn+ssh://$repo_base/$name/branches/$branch``. This definition
  automatically includes the ``subversion`` class.
  Please note: This definition is similar to ``subversion::working-copy`` and they
  might get merged in the future.

  - ``$name``: The name of the subversion project. This will be used
    to construct the URL used to check out the project.
  - ``$repo_base``: The base of the URL of the subversion
    repository. For example, if the subversion repository was located in
    ``/repository`` on the host ``subversion.example.com`` you would set
    ``$repo_base`` to ``subversion.example.com/repository``. This will
    be used to construct the URL used to check out the project.
  - ``$path``: The desired location of the working copy.
  - ``$branch``: (default: "trunk") The name of the branch you would
    like to check out. This will be used to construct the URL used to
    check out the project.
  - ``$svn_ssh``: (default: "false") If set, this will be used as the
    value of the SVN_SSH environment variable while running Subversion
    commands.
  - ``$owner``: (default: "root") The owner of the working copy.
  - ``$group``: (default: "root") The group of the working copy.

  Example::

    subversion::working-copy {
      "search":
        path => "/home/search/search",
        owner => "search",
        group => "search",
        repo_base => "svn.example.internal/repository",
        svn_ssh => "ssh -i /root/.ssh/puppet.rsa.key",
        require => User["search"];
    }

**subversion::svnrepo** (*definition*)
  Creates a subversion repository. It automatically includes 
  the subversion class.

  - ``$name``: The name of the subversion repository. This will be used
    as the directory name.
  - ``$path``: The path of the parent directory of the subversion repository
    Default is set to absent, which means that ``subversion::basics`` gets
    included and the parent directory is set to: ``/srv/svn/``
  - ``$owner``: The owner of the repository. Default is to false, which means
    that puppet defaults are used.
  - ``$group``: The group of the repository. Default is to false, which means
    that puppet defaults are used.
  - ``$mode``: The mode of the repository directory. Default is to false, which means
    that puppet defaults are used.
  - ``$selinux_context``: The selinux context of the repository directory, this only 
    applies if selinux is enabled.  Default is false which means no context is set.

  Example::

    subversion::svnrepo{'puppet-modules': }

**subversion::svnserve** (*definition*)
  Serve subversion-based code from a local location.  The job of this
  module is to check the data out from subversion and keep it up to
  date, especially useful for providing data to your Puppet server.
  Please note: This definition is similar to ``subversion::working-copy`` and they
  might get merged in the future.

  - ``$source``: From where to check the repository out
  - ``$path``: Where to place the checked out repository
  - ``$user``: User which might be used to access the repository.
    Default is set to false, which means that no user will be used.
  - ``$password``: The password for the above user. Default to false.

  Example::

    subversion::svnserve{ dist:
        source => "https://reductivelabs.com/svn",
        path => "/dist",
        user => "puppet",
        password => "mypassword"
    }

