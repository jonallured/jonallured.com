require "yaml"

describe "front matter keys" do
  it "only includes expected keys" do
    expected_keys = %w[date number tags title]

    files_with_bonus_keys = Dir.glob("source/_posts/*.md").select do |path|
      data = File.read(path)
      _empty, yaml, *_rest = data.split("---")
      front_matter = YAML.safe_load(yaml)
      actual_keys = front_matter.keys.sort
      bonus_keys = actual_keys - expected_keys
      bonus_keys.any?
    end

    expect(files_with_bonus_keys).to eq([])
  end
end
