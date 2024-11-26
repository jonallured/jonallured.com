describe "correctness" do
  it "builds the same number of files" do
    fd_command = 'fd . build --exclude "posts" --type file'

    mm_output = `cd ../mm-jonallured.com/ && #{fd_command}`
    mm_matches = mm_output.split("\n")

    system "rm -rf build && bundle exec jekyll build"
    jekyll_output = `#{fd_command}`
    jekyll_matches = jekyll_output.split("\n")

    expect(jekyll_matches).to match_array mm_matches
  end
end
