##
# Beacon 是管理 iBeacon 设备的封装类。

class Wechat::ShakeAround::Beacon

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  ##
  # 查询设备列表
  # http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E6.9F.A5.E8.AF.A2.E8.AE.BE.E5.A4.87.E5.88.97.E8.A1.A8
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     devices:
  #     [
  #       {
  #         comment:          '',
  #         device_id:        <DEVICE_ID>,
  #         major:            <MAJOR>,
  #         minor:            <MINOR>,
  #         status:           <STATUS>,           // 激活状态，0：未激活，1：已激活
  #         last_active_time: <LAST_ACTIVE_TIME>, // 设备最近一次被摇到的日期（最早只能获取前一天的数据）；新申请的设备该字段值为0
  #         poi_id:           <POI_ID>,           // 设备关联的门店ID，关联门店后，在门店1KM的范围内有优先摇出信息的机会。门店相关信息具体可查看门店相关的接口文档
  #         uuid:             <UUID>
  #       }
  #     ],
  #     total_count: <TOTAL_COUNT> // 商户名下的设备总量
  #   },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  def self.index(access_token, offset, limit, apply_id: nil)

    assert_present! :access_token, access_token
    assert_present! :offset,       offset
    assert_present! :limit,        limit

    options = { begin: offset, count: limit }
    if apply_id.present?
      options[:apply_id] = apply_id
      options[:type]     = 3
    else
      options[:type]     = 2
    end
    post_json "https://api.weixin.qq.com/shakearound/device/search?access_token=#{access_token}", body: options
  end

  ##
  # 查询设备
  # http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E6.9F.A5.E8.AF.A2.E8.AE.BE.E5.A4.87.E5.88.97.E8.A1.A8
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     devices:
  #     [
  #       {
  #         comment:          '',
  #         device_id:        <DEVICE_ID>,
  #         major:            <MAJOR>,
  #         minor:            <MINOR>,
  #         status:           <STATUS>,           // 激活状态，0：未激活，1：已激活
  #         last_active_time: <LAST_ACTIVE_TIME>, // 设备最近一次被摇到的日期（最早只能获取前一天的数据）；新申请的设备该字段值为0
  #         poi_id:           <POI_ID>,           // 设备关联的门店ID，关联门店后，在门店1KM的范围内有优先摇出信息的机会。门店相关信息具体可查看门店相关的接口文档
  #         uuid:             <UUID>
  #       }
  #     ],
  #     total_count: <TOTAL_COUNT> // 商户名下的设备总量
  #   },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  def self.load(access_token, device_id)

    assert_present! :access_token, access_token
    assert_present! :device_id,    device_id

    device_identifier = self.normalize_device_id device_id
    message = post_json "https://api.weixin.qq.com/shakearound/device/search?access_token=#{access_token}", body:
      {
        type:               1,
        device_identifiers: [ device_identifier ]
      }
    message.body
  end

  ##
  # 编辑设备信息
  # http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E7.BC.96.E8.BE.91.E8.AE.BE.E5.A4.87.E4.BF.A1.E6.81.AF
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # device_id is an integer or a hash like { uuid: <UUID>, major: <MAJOR>, minor: <MINOR> }.
  def self.update(access_token, device_id, comment)

    assert_present! :access_token, access_token
    assert_present! :device_id,    device_id
    assert_present! :comment,      comment

    device_identifier = self.normalize_device_id device_id
    message = post_json "https://api.weixin.qq.com/shakearound/device/update?access_token=#{access_token}",
      {
        device_identifier: device_identifier,
        comment:           comment
      }
    message.body
  end

end
