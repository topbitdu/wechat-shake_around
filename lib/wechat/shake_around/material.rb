require 'httpclient'

module Wechat::ShakeAround::Material

  # 上传图片素材
  # http://mp.weixin.qq.com/wiki/5/e997428269ff189d8f9a4b9e177be2d9.html
  #
  # Return hash format if success:
  # {
  #   data:    { pic_url: <ICON_LINK> },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # media 图片完整路径。
  # type 是icon或者license。
  def upload(access_token, media, type)

    raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = nil
    File.open(media) do |io|
      message = ::HTTPClient.new.post "https://api.weixin.qq.com/shakearound/material/add?access_token=#{access_token}&type=#{type}", { media: io }
    end
    body = message.try :body
    body.present? ? JSON.parse(body) : nil
  end

end
