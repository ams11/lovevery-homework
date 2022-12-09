class Gift < ProductPurchase
  validates :gift_comment, length: { maximum: 300, too_long: "cannot exceed 300 characters." }, allow_nil: true
end
