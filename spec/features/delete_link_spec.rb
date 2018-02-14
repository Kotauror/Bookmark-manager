feature "deleting links" do
  scenario "links are deleted" do
    visit("/")
    click_button("Delete link")
    fill_in("title", with: "Evil")
    click_button("Delete link")
    expect(current_path).to eq '/'
    expect(page).not_to have_content("Evil")
  end
end
