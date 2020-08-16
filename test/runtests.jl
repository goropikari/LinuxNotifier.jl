using LinuxNotifier, Test

# write your own tests here
@testset "Notification" begin
    @test try
        notify()
        true
    catch
        false
    end

    @test try
        notify("foo")
        true
    catch
        false
    end

    @test try
        notify("foo", title="bar")
        true
    catch
        false
    end

    @test try
        alarm()
        true
    catch
        false
    end

    @test try
        say("Hello")
        true
    catch
        false
    end
end
