##
# Apply 是批量申请 iBeacon 设备 UUID 、 Major 和 Minor 的封装类。

class Wechat::ShakeAround::Apply

  extend Wechat::Core::Common
  extend Wechat::ShakeAround::Common

  # 查询设备ID申请审核状态
  # http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E6.9F.A5.E8.AF.A2.E8.AE.BE.E5.A4.87ID.E7.94.B3.E8.AF.B7.E5.AE.A1.E6.A0.B8.E7.8A.B6.E6.80.81
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     apply_time:    <APPLY_TIME>,    // 提交申请的时间戳
  #     audit_comment: <AUDIT_COMMENT>, // 审核备注，对审核状态的文字说明
  #     audit_status:  <AUDIT_STATUS>,  // 审核状态。0：审核未通过、1：审核中、2：审核已通过；若单次申请的设备ID数量小于等于500个，系统会进行快速审核；若单次申请的设备ID数量大于500个，会在三个工作日内完成审核。
  #     audit_time:    <AUDIT_TIME>,    // 确定审核结果的时间戳，若状态为审核中，则该时间值为0
  #   },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  def self.load(access_token, apply_id)
    assert_present! :access_token, access_token
    assert_present! :apply_id,     apply_id

    message = post_json "https://api.weixin.qq.com/shakearound/device/applystatus?access_token=#{access_token}", body: { apply_id: apply_id.to_i }
    message.body
  end

  # 申请设备ID
  # http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html#.E7.94.B3.E8.AF.B7.E8.AE.BE.E5.A4.87ID
  #
  # Return hash format if success:
  # {
  #   data:
  #   {
  #     apply_id:      <APPLY_ID>,     // 申请的批次ID，可用在“查询设备列表”接口按批次查询本次申请成功的设备ID。
  #     audit_status:  <AUDIT_STATUS>, // 审核状态。0：审核未通过、1：审核中、2：审核已通过；若单次申请的设备ID数量小于等于500个，系统会进行快速审核；若单次申请的设备ID数量大于500个，会在三个工作日内完成审核；此时返回值全部为1(审核中)
  #     audit_comment: <AUDIT_COMMENT> // 审核备注，对审核状态的文字说明
  #   },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # quantity: 申请的设备ID的数量，单次新增设备超过500个，需走人工审核流程。
  # reason:   申请理由，不超过100个汉字或200个英文字母。
  # comment:  备注，不超过15个汉字或30个英文字母。
  def self.create(access_token, quantity, reason, comment: nil, poi_id: nil)

    assert_present! :access_token, access_token
    assert_present! :quantity,     quantity
    assert_present! :reason,       reason

    options = { quantity: quantity, apply_reason: reason }
    options[:comment] = comment if comment.present?
    options[:poi_id]  = poi_id  if poi_id.present?
    message = post_json "https://api.weixin.qq.com/shakearound/device/applyid?access_token=#{access_token}", body: options
    message.body
  end

end
