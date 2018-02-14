feature "deleting links" do
  scenario "links are deleted" do
    visit("/")
    click_button("Delete link")
    fill_in("title", with: "Evil")
    click_button("Delete link")
    expect(current_path).to eq '/'
    expect(page).not_to have_content("Evil")
  end

  scenario "puts flash message if there is no link" do
    visit("/")
    click_button("Delete link")
    fill_in("title", with: "Cats")
    click_button("Delete link")
    expect(page).to have_content("This title is not in the database")
  end
end
