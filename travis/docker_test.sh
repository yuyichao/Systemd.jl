#!/bin/bash

julia --color=yes -e 'Pkg.clone(pwd()); Pkg.build("Systemd")'
julia --color=yes --check-bounds=yes -e 'Pkg.test("Systemd", coverage=true)'
julia --color=yes -e 'cd(Pkg.dir("Systemd")); Pkg.add("Coverage"); using Coverage; Codecov.submit(process_folder())'
