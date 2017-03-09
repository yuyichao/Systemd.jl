using BinDeps

@BinDeps.setup

library_dependency("libsystemd", aliases=["libsystemd"])

BinDeps.debug("libsystemd")

@BinDeps.install Dict(:libsystemd => :libsystemd)
