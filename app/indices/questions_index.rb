ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title, sortable: true
  indexes body
  indexes user.email, sortable: true

  has user_id, created_at, updated_at
end
