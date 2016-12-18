require 'jsonclient'

class Wechat::ShakeAround::Shaking

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  # 获取摇周边的设备及用户信息
  # http://mp.weixin.qq.com/wiki/3/34904a5db3d0ec7bb5306335b8da1faf.html
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     page_id: <PAGE_ID>,
  #     openid:  <OPEN_ID>,
  #     poi_id:  <POI_ID>,
  #     beacon_info:
  #     {
  #       distance: <DISTANCE>,
  #       uuid:     <UUID>,
  #       major:    <MAJOR>,
  #       minor:    <MINOR>
  #     }
  #   },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  def self.load(access_token, ticket)

    assert_present! :access_token, access_token
    assert_present! :ticket,       ticket

    message = post_json "https://api.weixin.qq.com/shakearound/user/getshakeinfo?access_token=#{access_token}", body:
      {
        ticket:   ticket,
        need_poi: 1
      }
    message.body
  end

end
