describe "social images" do
  it "every post has one" do
    post_paths = Dir.glob("source/_posts/*.md")
    social_image_paths = Dir.glob("source/images/**/social-share.png")

    expect(social_image_paths.count).to eq post_paths.count
  end
end
