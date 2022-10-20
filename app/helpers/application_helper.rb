module ApplicationHelper
  def copyrights
    '© 2022 listing app. All Rights Reserved.'
  end

  def default_meta_tags
    {
      site: Settings.meta.site,
      reverse: true,
      title: Settings.meta.title,
      charset: 'utf-8',
      description: Settings.meta.description,
      keywords: Settings.meta.keywords,
      canonical: request.original_url,
      icon: [
        { href: image_url(Settings.meta.icon.favicon.image_path) },
        {
          href: image_url(Settings.meta.icon.apple_touch.image_path),
          rel: 'apple-touch-icon',
          sizes: '180x180',
          type: 'image/png'
        }
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: Settings.meta.og.type,
        url: request.original_url,
        image: image_url(Settings.meta.og.image_path),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end
end
