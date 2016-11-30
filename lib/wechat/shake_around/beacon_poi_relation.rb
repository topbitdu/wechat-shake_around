require 'jsonclient'

class Wechat::ShakeAround::BeaconPoiRelation

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  # 配置设备与门店的关联关系
  # http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E9.85.8D.E7.BD.AE.E8.AE.BE.E5.A4.87.E4.B8.8E.E9.97.A8.E5.BA.97.E7.9A.84.E5.85.B3.E8.81.94.E5.85.B3.E7.B3.BB
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  def self.create(access_token, device_id, poi_id)

    assert_present! :access_token, access_token
    assert_present! :device_id,    device_id
    assert_present! :poi_id,       poi_id

    device_identifier = self.normalize_device_id device_id
    message = post_json "https://api.weixin.qq.com/shakearound/device/bindlocation?access_token=#{access_token}", body:
      {
        device_identifier: device_identifier,
        poi_id:            poi_id.to_i
      }
    message.body
  end

end
