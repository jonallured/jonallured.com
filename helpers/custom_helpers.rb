# frozen_string_literal: true

module CustomHelpers
  def clean_summary(article)
    article.summary.gsub(%r{</?[^>]*>}, "").tr("\n", " ")
  end

  def headshot_url
    "https://www.jonallured.com/images/headshot.png"
  end

  def social_share_url(article)
    id = article.data.id
    local_path = "source/images/post-#{id}/social-share.png"

    return headshot_url unless File.exist?(local_path)

    "https://www.jonallured.com/images/post-#{id}/social-share.png"
  end

  def full_article_url(article)
    "https://www.jonallured.com#{article.url}"
  end
end
