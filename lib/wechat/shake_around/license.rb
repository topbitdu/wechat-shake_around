class Wechat::ShakeAround::License

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common
  extend Wechat::ShakeAround::Material

  # 上传图片素材
  # http://mp.weixin.qq.com/wiki/5/e997428269ff189d8f9a4b9e177be2d9.html
  #
  # Return hash format if success:
  # {
  #   data:    { pic_url: <LICENSE_LINK> },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # media 图片完整路径。
  def self.create(access_token, media)

    assert_present! :access_token, access_token
    assert_present! :media,        media

    upload access_token, media, 'license'
  end

end
