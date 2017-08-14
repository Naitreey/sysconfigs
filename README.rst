sysconfigs - A collection of system configuration modules
=========================================================

Module structure
----------------

- ``packages.d/packages-<distro>.yaml``

  a list of packages to be installed to system, where ``<distro>`` can be
  ``ubuntu``, ``fedora``, ``arch``, or ``any``. File format::

    - packagename1
    - packagename2

    ...

- ``files.d/files-<distro>.yaml``

  a list of files to installed to system. Files are by default symlinked to
  its target, unless otherwise defined by ``copy`` option. If ``asroot`` is
  ``true``, the particular link/copy will be done as root, suitable for modifying
  system level configurations. File format::

    - source: relpath/to/source1
      target: abspath/to/target1
      copy: true
    - source: relpath/to/source2
      target: abspath/to/target2
      copy: false
      asroot: true
    ...

  If ``target`` already exists, original file will be renamed to ``target.orig.<N>``
  before linking/copying.

- ``files.d/source/``

  a directory where source configuration files are kept.

- ``hooks.d/preinstall-<distro>``, ``hooks.d/postinstall-<distro>``

  scripts to be executed before/after configuration module installation.
  The scripts must be executable.

Operation logic
---------------

Each configuration module is created under ``modules.d`` directory
and named ``NNNN<module-name>``, where ``N`` is a digit of ``[0-9]``.
During configuring process, modules are applied in alpha-numeral order
as defined by ``NNNN<module-name>``.

During installation of each module, the followings are performed
in order.

# ``hooks.d/preinstall-<distro>`` is executed if exists.

# Packages listed in ``packages.d/files-<distro>.yaml`` are installed.

# Configuration and other files listed in ``files.d/files-<distro>.yaml``
  are linked/copied.

# ``hooks.d/postinstall-<distro>`` is executed if exists.
