class Reporter < User
  def agencies
    Agency.by_user_role(:reporter, [self.id])
  end

  def residences
    Residence.by_user_role(:reporter, [self.id])
  end

  def places
    Place.by_user_role(:reporter, [self.id])
  end

end