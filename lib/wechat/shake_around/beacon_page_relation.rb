##
# Beacon Page Relation 是管理 iBeacon 设备和页面之间关系的封装类。

class Wechat::ShakeAround::BeaconPageRelation

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  ##
  # 删除设备与页面的关联关系
  # http://mp.weixin.qq.com/wiki/12/c8120214ec0ba08af5dfcc0da1a11400.html
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  # page_id is an integer or an integer array.
  # bind 关联操作标志位，0为解除关联关系，1为建立关联关系
  # append 新增操作标志位，0为覆盖，1为新增
  def self.destroy(access_token, device_id, page_id)

    assert_present! :access_token, access_token
    assert_present! :device_id,    device_id
    assert_present! :page_id,      page_id

    device_identifier = normalize_device_id device_id
    page_ids          = normalize_page_ids  page_id

    post_json "https://api.weixin.qq.com/shakearound/device/bindpage?access_token=#{access_token}", body:
      {
        device_identifier: device_identifier,
        page_ids:          page_ids,
        bind:              0,
        append:            0
      }
  end

  ##
  # 创建设备与页面的关联关系
  # http://mp.weixin.qq.com/wiki/12/c8120214ec0ba08af5dfcc0da1a11400.html
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  # page_id is an integer or an integer array.
  # bind 关联操作标志位，0为解除关联关系，1为建立关联关系
  # append 新增操作标志位，0为覆盖，1为新增
  def self.create(access_token, device_id, page_id)

    assert_present! :access_token, access_token
    assert_present! :device_id,    device_id
    assert_present! :page_id,      page_id

    device_identifier = normalize_device_id device_id
    page_ids          = normalize_page_ids  page_id

    message = post_json "https://api.weixin.qq.com/shakearound/device/bindpage?access_token=#{access_token}", body:
      {
        device_identifier: device_identifier,
        page_ids:          page_ids,
        bind:              1,
        append:            1
      }
    message.body
  end

end
