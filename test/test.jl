using REPLCompletions
using Base.Test

module CompletionFoo
    const bar = 1
    foo() = bar
end

test_complete(s) = completions(s,endof(s))
test_scomplete(s) = shell_completions(s,endof(s))

s = ""
c,r = test_complete(s)
@test contains(c,"CompletionFoo")
@test r == 0:-1
@test s[r] == ""

s = "Comp"
c,r = test_complete(s)
@test contains(c,"CompletionFoo")
@test r == 1:4
@test s[r] == "Comp"

s = "Main.Comp"
c,r = test_complete(s)
@test contains(c,"CompletionFoo")
@test r == 6:9
@test s[r] == "Comp"

s = "Main.CompletionFoo."
c,r = test_complete(s)
@test contains(c,"bar")
@test r == 20:19
@test s[r] == ""

s = "Main.CompletionFoo.f"
c,r = test_complete(s)
@test contains(c,"foo")
@test r == 20:20
@test s[r] == "f"

@unix_only begin
    #Assume that we can rely on the existence and accessibility of /tmp
    s = "/t"
    c,r = test_scomplete("/t")
    @test contains(c,"tmp/")
    @test r == 2:2
    @test s[r] == "t"

    s = "/tmp"
    c,r = test_scomplete(s)
    @test contains(c,"tmp/")
    @test r == 2:4
    @test s[r] == "tmp"

    # This should match things that are inside the tmp directory
    if !isdir("/tmp/tmp")
        s = "/tmp/"
        c,r = test_scomplete(s)
        @test !contains(c,"tmp/")
        @test r == 6:5
        @test s[r] == ""
    end

    s = "cd \$(Pk"
    c,r = test_scomplete(s)
    @test contains(c,"Pkg")
    @test r == 6:7
    @test s[r] == "Pk"
end