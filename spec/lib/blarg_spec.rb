require "fileutils"
require_relative "../../lib/blarg"

RSpec.describe Blarg do
  describe ".setup_draft" do
    before(:each) do
      system("rm -rf tmp && mkdir tmp && cp spec/fixtures/before/* tmp/")
      allow(Dir).to receive(:glob).and_return(Array.new(76))
    end

    context "with valid path and type" do
      it "sets up the post and returns the post number" do
        tmp_path = "tmp/this-is-the-title.md"
        post_number = Blarg.setup_draft(tmp_path, "default")
        expect(post_number).to eq 77

        expected_file = "spec/fixtures/after/this-is-the-title.md"
        expect(FileUtils.compare_file(tmp_path, expected_file)).to eq true
      end
    end

    context "with the wir type" do
      it "uses the wir template" do
        tmp_path = "tmp/week-in-review-week-01-2025.md"
        Blarg.setup_draft(tmp_path, "wir")

        expected_file = "spec/fixtures/after/week-in-review-week-01-2025.md"
        expect(FileUtils.compare_file(tmp_path, expected_file)).to eq true
      end
    end
  end

  describe ".finalize_post" do
    before(:each) do
      system("rm -rf tmp && mkdir tmp && cp spec/fixtures/before/* tmp/")
      allow(Dir).to receive(:glob).and_return(Array.new(76))
    end

    context "with valid path" do
      it "sets up the post and returns the post number" do
        tmp_path = "tmp/2025-01-01-this-is-the-title.md"
        post_number = Blarg.finalize_post(tmp_path)
        expect(post_number).to eq 77

        expected_file = "spec/fixtures/after/2025-01-01-this-is-the-title.md"
        expect(FileUtils.compare_file(tmp_path, expected_file)).to eq true
      end
    end

    context "with favorite" do
      it "honors that favorite setting" do
        tmp_path = "tmp/2025-01-01-brand-new-favorite.md"
        Blarg.finalize_post(tmp_path)

        expected_file = "spec/fixtures/after/2025-01-01-brand-new-favorite.md"
        expect(FileUtils.compare_file(tmp_path, expected_file)).to eq true
      end
    end

    context "with custom number" do
      it "honors that custom number" do
        tmp_path = "tmp/2025-01-01-this-one-goes-to-eleven.md"
        post_number = Blarg.finalize_post(tmp_path)
        expect(post_number).to eq 11

        expected_file = "spec/fixtures/after/2025-01-01-this-one-goes-to-eleven.md"
        expect(FileUtils.compare_file(tmp_path, expected_file)).to eq true
      end
    end
  end
end
