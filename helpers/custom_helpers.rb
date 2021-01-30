# frozen_string_literal: true

module CustomHelpers
  def clean_summary(article)
    article.summary.gsub(%r{</?[^>]*>}, '').gsub("\n", ' ')
  end

  def headshot_url
    'https://www.jonallured.com/images/headshot.png'
  end

  def social_share_url(article)
    id = article.data.id
    local_path = "source/images/post-#{id}/social-share.png"

    return headshot_url unless File.exist?(local_path)

    "https://www.jonallured.com/images/post-#{id}/social-share.png"
  end
end
