class Blarg
  def self.setup_draft(path, type)
    Dir.glob("source/_posts/*.md").count + 1
  end

  def self.finalize_post(path)
    Dir.glob("source/_posts/*.md").count + 1
  end
end
