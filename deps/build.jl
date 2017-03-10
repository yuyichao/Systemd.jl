using BinDeps

@BinDeps.setup

library_dependency("libsystemd", aliases=["libsystemd"])

@BinDeps.install Dict(:libsystemd => :libsystemd)
