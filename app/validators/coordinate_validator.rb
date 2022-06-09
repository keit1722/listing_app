class CoordinateValidator < ActiveModel::Validator
  def validate(record)
    return if record.lat.present? && record.lng.present?
    record.errors.add(:base, :no_coordinate_format)
  end
end
