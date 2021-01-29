# frozen_string_literal: true

module CustomHelpers
  def clean_summary(article)
    article.summary.gsub(%r{</?[^>]*>}, '')
  end
end
