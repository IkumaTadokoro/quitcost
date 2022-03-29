# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags  # rubocop:disable Metrics/MethodLength
    {
      site: 'quitcost',
      title: 'quitcost',
      reverse: true,
      charset: 'utf-8',
      description: '「無職になったらいくらかかる？」をいますぐ計算！',
      viewport: 'width=device-width, initial-scale=1.0',
      og: {
        title: :title,
        type: 'website',
        site_name: 'quitcost',
        description: :description,
        image: 'http://0.0.0.0:3000/ogp/ogp.png',
        url: 'http://0.0.0.0:3000'
      },
      twitter: {
        title: :title,
        card: 'summary_large_image',
        site: '@ikumatdkr',
        description: :description,
        image: 'http://0.0.0.0:3000/ogp/ogp.png',
        domain: 'http://0.0.0.0:3000'
      }
    }
  end
end
