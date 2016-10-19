require 'jsonclient'

class Wechat::ShakeAround::Registration

  extend Wechat::Core::Common
  extend ::Wechat::ShakeAround::Common

  # 查询审核状态
  # http://mp.weixin.qq.com/wiki/13/025f1d471dc999928340161c631c6635.html#.E6.9F.A5.E8.AF.A2.E5.AE.A1.E6.A0.B8.E7.8A.B6.E6.80.81
  #
  # Return hash format if success:
  # {
  #   data: {
  #     apply_time:    APPLY_TIME,
  #     audit_comment: AUDIT_COMMENT,
  #     audit_status:  AUDIT_STATUS,
  #     audit_time:    AUDIT_TIME
  #   },
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  #
  # apply_time:    提交申请的时间戳
  # apply_comment: 审核备注，包括审核不通过的原因
  # audit_status:  0：审核未通过、1：审核中、2：审核已通过
  # audit_time:    确定审核结果的时间戳；若状态为审核中，则该时间值为0
  def self.load(access_token)

    assert_present! :access_token, access_token

    message = ::JSONClient.new.get "https://api.weixin.qq.com/shakearound/account/auditstatus?access_token=#{access_token}"
    message.body
  end

  # 申请开通功能
  # http://mp.weixin.qq.com/wiki/13/025f1d471dc999928340161c631c6635.html#.E7.94.B3.E8.AF.B7.E5.BC.80.E9.80.9A.E5.8A.9F.E8.83.BD
  # 成功提交申请请求后，工作人员会在三个工作日内完成审核。
  # 若审核不通过，可以重新提交申请请求。
  # 若是审核中，请耐心等待工作人员审核，在审核中状态不能再提交申请请求。
  # industry_id: http://3gimg.qq.com/shake_nearby/Qualificationdocuments.html
  #
  # Return hash format if success:
  # {
  #   data:    {},
  #   errcode: 0,
  #   errmsg:  'success.'
  # }
  def self.create(access_token, name, phone_number, email, industry_id, qualification_links, apply_reason)

    assert_present! :access_token, access_token
    assert_present! :name, name
    assert_present! :phone_number, phone_number
    #raise ArgumentError.new('The access_token argument is required.') if access_token.blank?

    message = ::JSONClient.new.post "https://api.weixin.qq.com/shakearound/account/register?access_token=#{access_token}",
      {
        name:                    name,
        phone_number:            phone_number,
        email:                   email,
        industry_id:             industry_id,
        qualification_cert_urls: qualification_links,
        apply_reason:            apply_reason
      }
    message.body
  end

end
