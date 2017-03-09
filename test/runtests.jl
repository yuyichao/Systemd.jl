#!/usr/bin/julia -f

import Systemd: Pid, Peer
using Base.Test

const pid = getpid()

@testset "Login" begin
    @test Pid.get_session(pid) isa String
    @test_throws SystemError Pid.get_session(1)
    @test Pid.get_owner_uid(pid) isa Int32
    @test_throws SystemError Pid.get_owner_uid(1)
    @test Pid.get_unit(pid) isa String
    @test_throws SystemError Pid.get_user_unit(pid)
    @test_throws SystemError Pid.get_user_unit(1)
    @test Pid.get_slice(pid) isa String
    @test Pid.get_user_slice(pid) isa String
    @test_throws SystemError Pid.get_user_slice(1)
    try
        machine_name = Pid.get_machine_name(pid)
        @test machine_name isa String
    catch ex
        @test ex isa SystemError
    end
    @test Pid.get_cgroup(pid) isa String
end
