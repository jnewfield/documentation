---
title: Changelog
weight: 90000
toc: true
nd-docs: DOCS-1695
---

```text
Changes with Unit 1.34.2                                         26 Feb 2025

    *) Security: fix missing websocket payload length validation in the Java
       language module which could lead to Java language module processes
       consuming excess CPU. (CVE-2025-1695).

    *) Bugfix: fix incorrect websocket payload length calculation in the
       Java language module.

Changes with Unit 1.34.1                                         10 Jan 2025

    *) Bugfix: fix instability issues due to OpenTelemetry (OTEL) support.

    *) Bugfix: fix issues with building OpenTelemetry (OTEL) support on
       various platforms, including macOS.


Changes with Unit 1.34.0                                         19 Dec 2024

    *) Feature: initial OpenTelemetry (OTEL) support. (Disabled by default).

    *) Feature: support for JSON formatted access logs.

    *) Bugfix: tweak the Perl language module to avoid breaking scripts in
       some circumstances.


Changes with Unit 1.33.0                                         17 Sep 2024

    *) Feature: make the number of router threads configurable.

    *) Feature: make the listen(2) backlog configurable.

    *) Feature: add Python application factory support.

    *) Feature: add experimental chunked request body support. (Disabled by
       default).

    *) Feature: add fuzzing via oss-fuzz.

    *) Feature: add "if" option to the "match" object.

    *) Feature: show list of loaded language modules in the /status
       endpoint.

    *) Feature: Unit ships with a new Rust based CLI application "unitctl".

    *) Feature: the wasm-wasi-component language module now inherits the
       processes environment.

    *) Change: under systemd unit runs in forking mode (once again).

    *) Change: if building with njs, version 0.8.3 or later is now required.

    *) Change: Unit now builds with -std=gnu11 (C11 with GNU extensions).

    *) Change: Unit now creates the full directory path for the PID file and
       control socket.

    *) Change: build system improvements, including pretty printing the make
       output and enabling various make variables to influence the build
       process (see: make help).

    *) Change: better detection of available runnable CPUs on Linux.

    *) Change: default listen(2) backlog on Linux now defaults to Kernel
       default.

    *) Bugfix: don't modify REQUEST_URI.

    *) Bugfix: fix a crash when interrupting a download via a proxy.

    *) Bugfix: wasm-wasi-component application process hangs after receiving
       restart signal from the control endpoint.

    *) Bugfix: njs variables accessed with a JS template literal should not
       be cacheable.

    *) Bugfix: properly handle deleting arrays of certificates.

    *) Bugfix: don't create the $runstatedir directory which triggered an
       Alpine packaging error.


Changes with Unit 1.32.1                                         26 Mar 2024

    *) Bugfix: NJS variables in templates may have incorrect values due to
       improper caching.

    *) Bugfix: Wasm application process hangs after receiving restart signal
       from the control.


Changes with Unit 1.32.0                                         27 Feb 2024

    *) Feature: WebAssembly Components using WASI interfaces defined in
       wasi:http/proxy@0.2.0.

    *) Feature: conditional access logging.

    *) Feature: njs variables access.

    *) Feature: $request_id variable contains a string that is formed using
       random data and can be used as a unique request identifier.

    *) Feature: options to set control socket permissions.

    *) Feature: Ruby arrays in response headers, improving compatibility
       with Rack v3.0.

    *) Feature: Python bytearray response bodies for ASGI applications.

    *) Bugfix: router could crash while sending large files. Thanks to
       rustedsword.

    *) Bugfix: serving static files from a network filesystem could lead to
       error.

    *) Bugfix: "uidmap" and "gidmap" isolation options validation.

    *) Bugfix: abstract UNIX socket name could be corrupted during
       configuration validation. Thanks to Alejandro Colomar.

    *) Bugfix: HTTP header field value encoding could be misinterpreted in
       Python module.

    *) Bugfix: Node.js http.createServer() accepts and ignores the "options"
       argument, improving compatibility with strapi applications, among
       others.

    *) Bugfix: ServerRequest.flushHeaders() implemented in Node.js module to
       make it compatible with Next.js.

    *) Bugfix: ServerRequest.httpVersion variable format in Node.js module.

    *) Bugfix: Node.js module handles standard library imports prefixed with
       "node:", making it possible to run newer Nuxt applications, among
       others.

    *) Bugfix: Node.js tarball location changed to avoid build/install
       errors.

    *) Bugfix: Go module sets environment variables necessary for building
       on macOS/arm64 systems.


Changes with Unit 1.31.1                                         19 Oct 2023

    *) Feature: allow to set the HTTP response status in Wasm module.

    *) Feature: allow uploads larger than 4GiB in Wasm module.

    *) Bugfix: application process could crash while rewriting URLs with
       query strings.

    *) Bugfix: requests larger than about 64MiB could cause error in Wasm
       module.

    *) Bugfix: when using many headers in Java module some of them could be
       corrupted due to memory realocation issue.

    *) Bugfix: ServerRequest.destroy() implemented in Node.js module to make
       it compatible with some frameworks that might use it.

    *) Bugfix: chunk argument of ServerResponse.write() can now be a
       Uint8Array to improve compatibility with Node.js 15.0.0 and above.

    *) Bugfix: Node.JS unit-http NPM module now has appropriate default
       paths for macOS/arm64 systems.

    *) Bugfix: build on musl libc with clang.


Changes with Unit 1.31.0                                         31 Aug 2023

    *) Change: if building with njs, version 0.8.0 or later is now required.

    *) Feature: technology preview of WebAssembly application module.

    *) Feature: "response_headers" option to manage headers in the action
       and fallback.

    *) Feature: HTTP response header variables.

    *) Feature: ASGI lifespan state support. Thanks to synodriver.

    *) Bugfix: ensure that $uri variable is not cached.

    *) Bugfix: deprecated options were unavailable.

    *) Bugfix: ASGI applications inaccessible over IPv6.


Changes with Unit 1.30.0                                         10 May 2023

    *) Change: remove Unix domain listen sockets upon reconfiguration.

    *) Feature: basic URI rewrite support.

    *) Feature: njs loadable modules support.

    *) Feature: per-application logging.

    *) Feature: conditional logging of route selection.

    *) Feature: support the keys API on the request objects in njs.

    *) Feature: default values for 'make install' pathnames such as prefix;
       this allows to './configure && make && sudo make install'.

    *) Feature: "server_version" setting to omit the version token from
       "Server" header field.

    *) Bugfix: request header field values could be corrupted in some cases;
       the bug had appeared in 1.29.0.

    *) Bugfix: PHP error handling (added missing 403 and 404 errors).

    *) Bugfix: Perl applications crash on second responder call.


Changes with Unit 1.29.1                                         28 Feb 2023

    *) Bugfix: stop creating world-writeable directories.

    *) Bugfix: memory leak related to njs.

    *) Bugfix: path parsing in PHP applications.

    *) Bugfix: enabled UTF-8 for Python config by default to avoid
       applications failing in some cases.

    *) Bugfix: using asyncio.get_running_loop() instead of
       asyncio.get_event_loop() when it's available to prevent errors in
       some Python ASGI applications.

    *) Bugfix: applications that make use of various low level APIs such as
       pthreads could fail to work correctly.

    *) Bugfix: websocket endianness detection for obscure operating systems.


Changes with Unit 1.29.0                                         15 Dec 2022

    *) Change: removed $uri auto-append for "share" when loading
       configuration.

    *) Change: prefer system crypto policy instead of hardcoding a default.

    *) Feature: njs support with the basic syntax of JS template literals.

    *) Feature: support per-application cgroups on Linux.

    *) Feature: the $request_time variable contains the request processing
       time.

    *) Feature: "prefix" option in Python applications to set WSGI
       "SCRIPT_NAME" and ASGI root-path variables.

    *) Feature: compatibility with Python 3.11.

    *) Feature: compatibility with OpenSSL 3.

    *) Feature: compatibility with PHP 8.2.

    *) Feature: compatibility with Node.js 19.0.

    *) Feature: Ruby Rack v3 support.

    *) Bugfix: fix error in connection statistics when using proxy.

    *) Bugfix: fix HTTP cookie parsing when the value contains an equals
       sign.

    *) Bugfix: PHP directory URLs without a trailing '/' would give a 503
       error (fixed with a 301 re-direct).

    *) Bugfix: missing error checks in the C API.

    *) Bugfix: report the regex status in configure summary.


Changes with Unit 1.28.0                                         13 Sep 2022

    *) Change: increased the applications' startup timeout.

    *) Change: disallowed abstract Unix domain socket syntax in non-Linux
       systems.

    *) Feature: basic statistics API.

    *) Feature: customizable access log format.

    *) Feature: more HTTP variables support.

    *) Feature: forwarded header to replace client address and protocol.

    *) Feature: ability to get dynamic variables.

    *) Feature: support for abstract Unix sockets.

    *) Feature: support for Unix sockets in address matching.

    *) Feature: the $dollar variable translates to a literal "$" during
       variable substitution.

    *) Bugfix: router process could crash if index file didn't contain an
       extension.

    *) Bugfix: force SCRIPT_NAME in Ruby to always be an empty string.

    *) Bugfix: when isolated PID numbers reach the prototype process host
       PID, the prototype crashed.

    *) Bugfix: the Ruby application process could crash on SIGTERM.

    *) Bugfix: the Ruby application process could crash on SIGINT.

    *) Bugfix: mutex leak in the C API.


Changes with Unit 1.27.0                                         02 Jun 2022

    *) Feature: ability to specify a custom index file name when serving
       static files.

    *) Feature: variables support in the "location" option of the "return"
       action.

    *) Feature: support empty strings in the "location" option of the
       "return" action.

    *) Feature: added a new variable, $request_uri, that includes both the
       path and the query parts as per RFC 3986, sections 3-4.

    *) Feature: Ruby Rack environment parameter "SCRIPT_NAME" support.

    *) Feature: compatibility with GCC 12.

    *) Bugfix: Ruby Sinatra applications don't work without custom logging.

    *) Bugfix: the controller process could crash when a chain of more than
       four certificates was uploaded.

    *) Bugfix: some Perl applications failed to process the request body,
       notably with Plack.

    *) Bugfix: some Spring Boot applications failed to start, notably with
       Grails.

    *) Bugfix: incorrect Python protocol auto detection (ASGI or WSGI) for
       native callable object, notably with Falcon.

    *) Bugfix: ECMAScript modules did not work with the recent Node.js
       versions.


Changes with Unit 1.26.1                                         02 Dec 2021

    *) Bugfix: occasionally, the Unit daemon was unable to fully terminate;
       the bug had appeared in 1.26.0.

    *) Bugfix: a prototype process could crash on an application process
       exit; the bug had appeared in 1.26.0.

    *) Bugfix: the router process crashed on reconfiguration if "access_log"
       was configured without listeners.

    *) Bugfix: a segmentation fault occurred in the PHP module if chdir() or
       fastcgi_finish_request() was called in the OPcache preloading script.

    *) Bugfix: fatal errors on DragonFly BSD; the bug had appeared in
       1.26.0.


Changes with Unit 1.26.0                                         18 Nov 2021

    *) Change: the "share" option now specifies the entire path to the files
       it serves, rather than a document root directory to be prepended to
       the request URI.

    *) Feature: automatic adjustment of existing configurations to the new
       "share" behavior when updating from previous versions.

    *) Feature: variables support in the "share" option.

    *) Feature: multiple paths in the "share" option.

    *) Feature: variables support in the "chroot" option.

    *) Feature: PHP opcache is shared between application processes.

    *) Feature: request routing by the query string.

    *) Bugfix: the router and app processes could crash when the requests
       limit was reached by asynchronous or multithreaded apps.

    *) Bugfix: established WebSocket connections could stop reading frames
       from the client after the corresponding listener had been
       reconfigured.

    *) Bugfix: fixed building with glibc 2.34, notably Fedora 35.


Changes with Unit 1.25.0                                         19 Aug 2021

    *) Feature: client IP address replacement from a specified HTTP header
       field.

    *) Feature: TLS sessions cache.

    *) Feature: TLS session tickets.

    *) Feature: application restart control.

    *) Feature: process and thread lifecycle hooks in Ruby.

    *) Bugfix: the router process could crash on TLS connection open when
       multiple listeners with TLS certificates were configured; the bug had
       appeared in 1.23.0.

    *) Bugfix: TLS connections were rejected for configurations with
       multiple certificate bundles in a listener if the client did not use
       SNI.

    *) Bugfix: the router process could crash with frequent multithreaded
       application reconfiguration.

    *) Bugfix: compatibility issues with some Python ASGI apps, notably
       based on the Starlette framework.

    *) Bugfix: a descriptor and memory leak occurred in the router process
       when an app process stopped or crashed.

    *) Bugfix: the controller or router process could crash if the
       configuration contained a full-form IPv6 in a listener address.

    *) Bugfix: the router process crashed when a request was passed to an
       empty "routes" or "upstreams" using a variable "pass" option.

    *) Bugfix: the router process crashed while matching a request to an
       empty array of source or destination address patterns.


Changes with Unit 1.24.0                                         27 May 2021

    *) Change: PHP added to the default MIME type list.

    *) Feature: arbitrary configuration of TLS connections via OpenSSL
       commands.

    *) Feature: the ability to limit static file serving by MIME types.

    *) Feature: support for chrooting, rejecting symlinks, and rejecting
       mount point traversal on a per-request basis when serving static
       files.

    *) Feature: a loader for automatically overriding the "http" and
       "websocket" modules in Node.js.

    *) Feature: multiple "targets" in Python applications.

    *) Feature: compatibility with Ruby 3.0.

    *) Bugfix: the router process could crash while closing a TLS
       connection.

    *) Bugfix: a segmentation fault might have occurred in the PHP module if
       fastcgi_finish_request() was used with the "auto_globals_jit" option
       enabled.


Changes with Unit 1.23.0                                         25 Mar 2021

    *) Feature: support for multiple certificate bundles on a listener via
       the Server Name Indication (SNI) TLS extension.

    *) Feature: "--mandir" ./configure option to specify the directory for
       man page installation.

    *) Bugfix: the router process could crash on premature TLS connection
       close; the bug had appeared in 1.17.0.

    *) Bugfix: a connection leak occurred on premature TLS connection close;
       the bug had appeared in 1.6.

    *) Bugfix: a descriptor and memory leak occurred in the router process
       when processing small WebSocket frames from a client; the bug had
       appeared in 1.19.0.

    *) Bugfix: a descriptor leak occurred in the router process when
       removing or reconfiguring an application; the bug had appeared in
       1.19.0.

    *) Bugfix: persistent storage of certificates might've not worked with
       some filesystems in Linux, and all uploaded certificate bundles were
       forgotten after restart.

    *) Bugfix: the controller process could crash while requesting
       information about a certificate with a non-DNS SAN entry.

    *) Bugfix: the controller process could crash on manipulations with a
       certificate containing a SAN and no standard name attributes in
       subject or issuer.

    *) Bugfix: the Ruby module didn't respect the user locale for defaults
       in the Encoding class.

    *) Bugfix: the PHP 5 module failed to build with thread safety enabled;
       the bug had appeared in 1.22.0.


Changes with Unit 1.22.0                                         04 Feb 2021

    *) Feature: the ServerRequest and ServerResponse objects of Node.js
       module are now compliant with Stream API.

    *) Feature: support for specifying multiple directories in the "path"
       option of Python apps.

    *) Bugfix: a memory leak occurred in the router process when serving
       files larger than 128K; the bug had appeared in 1.13.0.

    *) Bugfix: apps could stop processing new requests under high load; the
       bug had appeared in 1.19.0.

    *) Bugfix: app processes could terminate unexpectedly under high load;
       the bug had appeared in 1.19.0.

    *) Bugfix: invalid HTTP responses were generated for some unusual status
       codes.

    *) Bugfix: the PHP_AUTH_USER, PHP_AUTH_PW, and PHP_AUTH_DIGEST server
       variables were missing in the PHP module.

    *) Bugfix: the router process could crash with multithreaded apps under
       high load.

    *) Bugfix: Ruby apps with multithreading configured could crash on start
       under load.

    *) Bugfix: mount points weren't unmounted when the "mount" namespace
       isolation was used; the bug had appeared in 1.21.0.

    *) Bugfix: the router process could crash while removing or
       reconfiguring an app that used WebSocket.

    *) Bugfix: a memory leak occurring in the router process when removing
       or reconfiguring an application; the bug had appeared in 1.19.0.


Changes with Unit 1.21.0                                         19 Nov 2020

    *) Change: procfs is mounted by default for all languages when "rootfs"
       isolation is used.

    *) Change: any characters valid according to RFC 7230 are now allowed in
       HTTP header field names.

    *) Change: HTTP header fields with underscores ("_") are now discarded
       from requests by default.

    *) Feature: optional multithreaded request processing for Java, Python,
       Perl, and Ruby apps.

    *) Feature: regular expressions in route matching patterns.

    *) Feature: compatibility with Python 3.9.

    *) Feature: the Python module now supports ASGI 2.0 legacy applications.

    *) Feature: the "protocol" option in Python applications aids choice
       between ASGI and WSGI.

    *) Feature: the fastcgi_finish_request() PHP function that finalizes
       request processing and continues code execution without holding onto
       the client connection.

    *) Feature: the "discard_unsafe_fields" HTTP option that enables
       discarding request header fields with irregular (but still valid)
       characters in the field name.

    *) Feature: the "procfs" and "tmpfs" automount isolation options to
       disable automatic mounting of eponymous filesystems.

    *) Bugfix: the router process could crash when running Go applications
       under high load; the bug had appeared in 1.19.0.

    *) Bugfix: some language dependencies could remain mounted after using
       "rootfs" isolation.

    *) Bugfix: various compatibility issues in Java applications.

    *) Bugfix: the Java module built with the musl C library couldn't run
       applications that use "rootfs" isolation.


Changes with Unit 1.20.0                                         08 Oct 2020

    *) Change: the PHP module is now initialized before chrooting; this
       enables loading all extensions from the host system.

    *) Change: AVIF and APNG image formats added to the default MIME type
       list.

    *) Change: functional tests migrated to the pytest framework.

    *) Feature: the Python module now fully supports applications that use
       the ASGI 3.0 server interface.

    *) Feature: the Python module now has a built-in WebSocket server
       implementation for applications, compatible with the HTTP & WebSocket
       ASGI Message Format 2.1 specification.

    *) Feature: automatic mounting of an isolated "/tmp" file system into
       chrooted application environments.

    *) Feature: the $host variable contains a normalized "Host" request
       value.

    *) Feature: the "callable" option sets Python application callable
       names.

    *) Feature: compatibility with PHP 8 RC 1. Thanks to Remi Collet.

    *) Feature: the "automount" option in the "isolation" object allows to
       turn off the automatic mounting of language module dependencies.

    *) Bugfix: "pass"-ing requests to upstreams from a route was broken; the
       bug had appeared in 1.19.0. Thanks to 洪志道 (Hong Zhi Dao) for
       discovering and fixing it.

    *) Bugfix: the router process could crash during reconfiguration.

    *) Bugfix: a memory leak occurring in the router process; the bug had
       appeared in 1.18.0.

    *) Bugfix: the "!" (non-empty) pattern was matched incorrectly; the bug
       had appeared in 1.19.0.

    *) Bugfix: fixed building on platforms without sendfile() support,
       notably NetBSD; the bug had appeared in 1.16.0.


Changes with Unit 1.19.0                                         13 Aug 2020

    *) Feature: reworked IPC between the router process and the applications
       to lower latencies, increase performance, and improve scalability.

    *) Feature: support for an arbitrary number of wildcards in route
       matching patterns.

    *) Feature: chunked transfer encoding in proxy responses.

    *) Feature: basic variables support in the "pass" option.

    *) Feature: compatibility with PHP 8 Beta 1. Thanks to Remi Collet.

    *) Bugfix: the router process could crash while passing requests to an
       application under high load.

    *) Bugfix: a number of language modules failed to build on some systems;
       the bug had appeared in 1.18.0.

    *) Bugfix: time in error log messages from PHP applications could lag.

    *) Bugfix: reconfiguration requests could hang if an application had
       failed to start; the bug had appeared in 1.18.0.

    *) Bugfix: memory leak during reconfiguration.

    *) Bugfix: the daemon didn't start without language modules; the bug had
       appeared in 1.18.0.

    *) Bugfix: the router process could crash at exit.

    *) Bugfix: Node.js applications could crash at exit.

    *) Bugfix: the Ruby module could be linked against a wrong library
       version.


Changes with Unit 1.18.0                                         28 May 2020

    *) Feature: the "rootfs" isolation option for changing root filesystem
       for an application.

    *) Feature: multiple "targets" in PHP applications.

    *) Feature: support for percent-encoding in the "uri" and "arguments"
       matching options and in the "pass" option.


Changes with Unit 1.17.0                                         16 Apr 2020

    *) Feature: a "return" action with optional "location" for immediate
       responses and external redirection.

    *) Feature: fractional weights support for upstream servers.

    *) Bugfix: accidental 502 "Bad Gateway" errors might have occurred in
       applications under high load.

    *) Bugfix: memory leak in the router; the bug had appeared in 1.13.0.

    *) Bugfix: segmentation fault might have occurred in the router process
       when reaching open connections limit.

    *) Bugfix: "close() failed (9: Bad file descriptor)" alerts might have
       appeared in the log while processing large request bodies; the bug
       had appeared in 1.16.0.

    *) Bugfix: existing application processes didn't reopen the log file.

    *) Bugfix: incompatibility with some Node.js applications.

    *) Bugfix: broken build on DragonFly BSD; the bug had appeared in
       1.16.0.


Changes with Unit 1.16.0                                         12 Mar 2020

    *) Feature: basic load-balancing support with round-robin.

    *) Feature: a "fallback" option that performs an alternative action if a
       request can't be served from the "share" directory.

    *) Feature: reduced memory consumption by dumping large request bodies
       to disk.

    *) Feature: stripping UTF-8 BOM and JavaScript-style comments from
       uploaded JSON.

    *) Bugfix: negative address matching in router might work improperly in
       combination with non-negative patterns.

    *) Bugfix: Java Spring applications failed to run; the bug had appeared
       in 1.10.0.

    *) Bugfix: PHP 7.4 was broken if it was built with thread safety
       enabled.

    *) Bugfix: compatibility issues with some Python applications.


Changes with Unit 1.15.0                                         06 Feb 2020

    *) Change: extensions of dynamically requested PHP scripts were
       restricted to ".php".

    *) Feature: compatibility with Ruby 2.7.

    *) Bugfix: segmentation fault might have occurred in the router process
       with multiple application processes under load; the bug had appeared
       in 1.14.0.

    *) Bugfix: receiving request body over TLS connection might have
       stalled.


Changes with Unit 1.14.0                                         26 Dec 2019

    *) Change: the Go package import name changed to "unit.nginx.org/go".

    *) Change: Go package now links to libunit instead of including library
       sources.

    *) Feature: ability to change user and group for isolated applications
       when Unit daemon runs as an unprivileged user.

    *) Feature: request routing by source and destination addresses and
       ports.

    *) Bugfix: memory bloat on large responses.


Changes with Unit 1.13.0                                         14 Nov 2019

    *) Feature: basic support for HTTP reverse proxying.

    *) Feature: compatibility with Python 3.8.

    *) Bugfix: memory leak in Python application processes when the close
       handler was used.

    *) Bugfix: threads in Python applications might not work correctly.

    *) Bugfix: Ruby on Rails applications might not work on Ruby 2.6.

    *) Bugfix: backtraces for uncaught exceptions in Python 3 might be
       logged with significant delays.

    *) Bugfix: explicit setting a namespaces isolation option to false might
       have enabled it.


Changes with Unit 1.12.0                                         03 Oct 2019

    *) Feature: compatibility with PHP 7.4.

    *) Bugfix: descriptors leak on process creation; the bug had appeared in
       1.11.0.

    *) Bugfix: TLS connection might be closed prematurely while sending
       response.

    *) Bugfix: segmentation fault might have occurred if an irregular file
       was requested.


Changes with Unit 1.11.0                                         19 Sep 2019

    *) Feature: basic support for serving static files.

    *) Feature: isolation of application processes with Linux namespaces.

    *) Feature: built-in WebSocket server implementation for Java Servlet
       Containers.

    *) Feature: direct addressing of API configuration options containing
       slashes "/" using URI encoding (%2F).

    *) Bugfix: segmentation fault might have occurred in Go applications
       under high load.

    *) Bugfix: WebSocket support was broken if Unit was built with some
       linkers other than GNU ld (e.g. gold or LLD).


Changes with Unit 1.10.0                                         22 Aug 2019

    *) Change: matching of cookies in routes made case sensitive.

    *) Change: decreased log level of common errors when clients close
       connections.

    *) Change: removed the Perl module's "--include=" ./configure option.

    *) Feature: built-in WebSocket server implementation for Node.js module.

    *) Feature: splitting PATH_INFO from request URI in PHP module.

    *) Feature: request routing by scheme (HTTP or HTTPS).

    *) Feature: support for multipart requests body in Java module.

    *) Feature: improved API compatibility with Node.js 11.10 or later.

    *) Bugfix: reconfiguration failed if "listeners" or "applications"
       objects were missing.

    *) Bugfix: applying a large configuration might have failed.


Changes with Unit 1.9.0                                          30 May 2019

    *) Feature: request routing by arguments, headers, and cookies.

    *) Feature: route matching patterns allow a wildcard in the middle.

    *) Feature: POST operation for appending elements to arrays in
       configuration.

    *) Feature: support for changing credentials using CAP_SETUID and
       CAP_SETGID capabilities on Linux without running main process as
       privileged user.

    *) Bugfix: memory leak in the router process might have happened when a
       client prematurely closed the connection.

    *) Bugfix: applying a large configuration might have failed.

    *) Bugfix: PUT and DELETE operations on array elements in configuration
       did not work.

    *) Bugfix: request schema in applications did not reflect TLS
       connections.

    *) Bugfix: restored compatibility with Node.js applications that use
       ServerResponse._implicitHeader() function; the bug had appeared in
       1.7.

    *) Bugfix: various compatibility issues with Node.js applications.


Changes with Unit 1.8.0                                          01 Mar 2019

    *) Change: now three numbers are always used for versioning: major,
       minor, and patch versions.

    *) Change: now QUERY_STRING is always defined even if the request does
       not include the query component.

    *) Feature: basic internal request routing by Host, URI, and method.

    *) Feature: experimental support for Java Servlet Containers.

    *) Bugfix: segmentation fault might have occurred in the router process.

    *) Bugfix: various potential memory leaks.

    *) Bugfix: TLS connections might have stalled.

    *) Bugfix: some Perl applications might have failed to send the response
       body.

    *) Bugfix: some compilers with specific flags might have produced
       non-functioning builds; the bug had appeared in 1.5.

    *) Bugfix: Node.js package had wrong version number when installed from
       sources.


Changes with Unit 1.7.1                                          07 Feb 2019

    *) Security: a heap memory buffer overflow might have been caused in the
       router process by a specially crafted request, potentially resulting
       in a segmentation fault or other unspecified behavior
       (CVE-2019-7401).

    *) Bugfix: install of Go module failed without prior building of Unit
       daemon; the bug had appeared in 1.7.


Changes with Unit 1.7                                            20 Dec 2018

    *) Change: now rpath is set in Ruby module only if the library was not
       found in default search paths; this allows to meet packaging
       restrictions on some systems.

    *) Bugfix: "disable_functions" and "disable_classes" PHP options set via
       Control API did not work.

    *) Bugfix: Promises on request data in Node.js were not triggered.

    *) Bugfix: various compatibility issues with Node.js applications.

    *) Bugfix: a segmentation fault occurred in Node.js module if
       application tried to read request body after request.end() was
       called.

    *) Bugfix: a segmentation fault occurred in Node.js module if
       application attempted to send header twice.

    *) Bugfix: names of response header fields in Node.js module were
       erroneously treated as case-sensitive.

    *) Bugfix: uncatched exceptions in Node.js were not logged.

    *) Bugfix: global install of Node.js module from sources was broken on
       some systems; the bug had appeared in 1.6.

    *) Bugfix: traceback for exceptions during initialization of Python
       applications might not be logged.

    *) Bugfix: PHP module build failed if PHP interpreter was built with
       thread safety enabled.


Changes with Unit 1.6                                            15 Nov 2018

    *) Change: "make install" now installs Node.js module as well if it was
       configured.

    *) Feature: "--local" ./configure option to install Node.js module
       locally.

    *) Bugfix: Node.js module might have crashed due to broken reference
       counting.

    *) Bugfix: asynchronous operations in Node.js might not have worked.

    *) Bugfix: various compatibility issues with Node.js applications.

    *) Bugfix: "freed pointer is out of pool" alerts might have appeared in
       log.

    *) Bugfix: module discovery did not work on 64-bit big-endian systems
       like IBM/S390x.


Changes with Unit 1.5                                            25 Oct 2018

    *) Change: the "type" of application object for Go was changed to
       "external".

    *) Feature: initial version of Node.js package with basic HTTP
       request-response support.

    *) Feature: compatibility with LibreSSL.

    *) Feature: --libdir and --incdir ./configure options to install libunit
       headers and static library.

    *) Bugfix: connection might be closed prematurely while sending
       response; the bug had appeared in 1.3.

    *) Bugfix: application processes might have stopped handling requests,
       producing "last message send failed: Resource temporarily
       unavailable" alerts in log; the bug had appeared in 1.4.

    *) Bugfix: Go applications did not work when Unit was built with musl C
       library.


Changes with Unit 1.4                                            20 Sep 2018

    *) Change: the control API maps the configuration object only at
       "/config/".

    *) Feature: TLS support for client connections.

    *) Feature: TLS certificates storage control API.

    *) Feature: Unit library (libunit) to streamline language module
       integration.

    *) Feature: "408 Request Timeout" responses while closing HTTP
       keep-alive connections.

    *) Feature: improvements in OpenBSD support. Thanks to David Carlier.

    *) Bugfix: a segmentation fault might have occurred after
       reconfiguration.

    *) Bugfix: building on systems with non-default locale might be broken.

    *) Bugfix: "header_read_timeout" might not work properly.

    *) Bugfix: header fields values with non-ASCII bytes might be handled
       incorrectly in Python 3 module.


Changes with Unit 1.3                                            13 Jul 2018

    *) Change: UTF-8 characters are now allowed in request header field
       values.

    *) Feature: configuration of the request body size limit.

    *) Feature: configuration of various HTTP connection timeouts.

    *) Feature: Ruby module now automatically uses Bundler where possible.

    *) Feature: http.Flusher interface in Go module.

    *) Bugfix: various issues in HTTP connection errors handling.

    *) Bugfix: requests with body data might be handled incorrectly in PHP
       module.

    *) Bugfix: individual PHP configuration options specified via control
       API were reset to previous values after the first request in
       application process.


Changes with Unit 1.2                                            07 Jun 2018

    *) Feature: configuration of environment variables for application
       processes.

    *) Feature: customization of php.ini path.

    *) Feature: setting of individual PHP configuration options.

    *) Feature: configuration of execution arguments for Go applications.

    *) Bugfix: keep-alive connections might hang after reconfiguration.


Changes with Unit 1.1                                            26 Apr 2018

    *) Bugfix: Python applications that use the write() callable did not
       work.

    *) Bugfix: virtual environments created with Python 3.3 or above might
       not have worked.

    *) Bugfix: the request.Read() function in Go applications did not
       produce EOF when the whole body was read.

    *) Bugfix: a segmentation fault might have occurred while access log
       reopening.

    *) Bugfix: in parsing of IPv6 control socket addresses.

    *) Bugfix: loading of application modules was broken on OpenBSD.

    *) Bugfix: a segmentation fault might have occurred when there were two
       modules with the same type and version; the bug had appeared in 1.0.

    *) Bugfix: alerts "freed pointer points to non-freeble page" might have
       appeared in log on 32-bit platforms.


Changes with Unit 1.0                                            12 Apr 2018

    *) Change: configuration object moved into "/config/" path.

    *) Feature: basic access logging.

    *) Bugfix: 503 error occurred if Go application did not write response
       header or body.

    *) Bugfix: Ruby applications that use encoding conversions might not
       have worked.

    *) Bugfix: various stability issues.


Changes with Unit 0.7                                            22 Mar 2018

    *) Feature: Ruby application module.

    *) Bugfix: in discovering modules.

    *) Bugfix: various race conditions on reconfiguration and during
       shutting down.

    *) Bugfix: tabs and trailing spaces were not allowed in header fields
       values.

    *) Bugfix: a segmentation fault occurred in Python module if
       start_response() was called outside of WSGI callable.

    *) Bugfix: a segmentation fault might have occurred in PHP module if
       there was an error while initialization.


Changes with Unit 0.6                                            09 Feb 2018

    *) Bugfix: the main process died when the "type" application option
       contained version; the bug had appeared in 0.5.


Changes with Unit 0.5                                            08 Feb 2018

    *) Change: the "workers" application option was removed, the "processes"
       application option should be used instead.

    *) Feature: the "processes" application option with prefork and dynamic
       process management support.

    *) Feature: Perl application module.

    *) Bugfix: in reading client request body; the bug had appeared in 0.3.

    *) Bugfix: some Python applications might not have worked due to missing
       "wsgi.errors" environ variable.

    *) Bugfix: HTTP chunked responses might be encoded incorrectly on 32-bit
       platforms.

    *) Bugfix: infinite looping in HTTP parser.

    *) Bugfix: segmentation fault in router.


Changes with Unit 0.4                                            15 Jan 2018

    *) Feature: compatibility with DragonFly BSD.

    *) Feature: "configure php --lib-static" option.

    *) Bugfix: HTTP request body was not passed to application; the bug had
       appeared in 0.3.

    *) Bugfix: HTTP large header buffers allocation and deallocation fixed;
       the bug had appeared in 0.3.

    *) Bugfix: some PHP applications might not have worked with relative
       "root" path.


Changes with Unit 0.3                                            28 Dec 2017

    *) Change: the Go package name changed to "nginx/unit".

    *) Change: in the "limits.timeout" application option: application start
       time and time in queue now are not accounted.

    *) Feature: the "limits.requests" application option.

    *) Feature: application request processing latency optimization.

    *) Feature: HTTP keep-alive connections support.

    *) Feature: the "home" Python virtual environment configuration option.

    *) Feature: Python atexit hook support.

    *) Feature: various Go package improvements.

    *) Bugfix: various crashes fixed.


Changes with Unit 0.2                                            19 Oct 2017

    *) Feature: configuration persistence.

    *) Feature: improved handling of configuration errors.

    *) Feature: application "timeout" property.

    *) Bugfix: POST request for PHP were handled incorrectly.

    *) Bugfix: the router exited abnormally if all listeners had been
       deleted.

    *) Bugfix: the router crashed under load.

    *) Bugfix: memory leak in the router.


Changes with Unit 0.1                                            06 Sep 2017

    *) First public release.
```
