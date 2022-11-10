module NoticeableAssociation
  extend ActiveSupport::Concern

  included { has_many :notices, as: :noticeable, dependent: :destroy }

  def path_for_notice
    raise NotImplementedError, 'path_for_noticeが定義されていません'
  end
end
