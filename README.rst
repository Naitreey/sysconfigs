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

  hooks to be executed before/after configuration module installation.
  This can be any binary or script executable. The only constraint is
  the file's exec bits are set properly.

CLI interface
-------------

Operations are mainly executed via ``sysconfig`` script, which features the
following functionalities:

- Install the specified or all config modules.

- List available config modules.

- Show content of the specified config module.

- Initialize a new config module by creating boilerplate module directory
  and file structure.

Operation logic
---------------

Each configuration module is created under ``modules.d`` directory
and named ``NNNN<module-name>``, where ``N`` is a digit of ``[0-9]``.
During configuring process, modules are applied in alpha-numeral order
as defined by ``NNNN<module-name>``.

During installation of each module, the followings are performed
in order.

1. ``hooks.d/preinstall-<distro>`` is executed if exists.

2. Packages listed in ``packages.d/files-<distro>.yaml`` are installed.

3. Configuration and other files listed in ``files.d/files-<distro>.yaml``
   are linked/copied.

4. ``hooks.d/postinstall-<distro>`` is executed if exists.
