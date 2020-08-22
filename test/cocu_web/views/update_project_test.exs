defmodule CocuWeb.UpdateProjectTest do
    use CocuWeb.FeatureCase,
        async: true
  
    #  import Wallaby.Query
    #  import Wallaby.Browser
    #
    #  @edit_button css("#edit.write")
    #  @cancel_button css("#edit.window.close")
    #  @save_button css("#save")
    #
    #  @project_state_radio_buttons css(".project-phase .radio > label", count: 3)
    #  @project_state_spans css(".project-phase .radio > span", count: 3)
    #
    #  @any_project_state_radio_buttons css (".project-phase .radio > label", minimum: 1)
    #  @any_project_state_spans css(".project-phase .radio > span", minimum: 1)
    #
    #  @presentation_phase_selected css(".project-phase.phase-presentation.selected .radio")
    #  #@funding_phase_selected css(".project-phase.phase-funding.selected .radio")
    #  @creation_phase_selected css(".project-phase.phase-creation.selected .radio")
    #
    #  # The div.radio is the element that actually has the click event.
    #  @presentation_phase_radio css(".project-phase.phase-presentation .radio")
    #  #@funding_phase_radio css(".project-phase.phase-funding .radio")
    #  #@creation_phase_radio css(".project-phase.phase-creation .radio")
    #
    #  def assert_default_project_state(session) do
    #    session
    #    |> assert_has(@edit_button)
    #    |> refute_has(@save_button)
    #    |> refute_has(@cancel_button)
    #    |> refute_has(@any_project_state_radio_buttons)
    #    |> assert_has(@project_state_spans)
    #
    #  end
    #
    #  def assert_edit_project_state(session) do
    #    session
    #    |> refute_has(@edit_button)
    #    |> assert_has(@save_button)
    #    |> assert_has(@cancel_button)
    #    |> assert_has(@project_state_radio_buttons)
    #    |> refute_has(@any_project_state_spans)
    #  end
    #
    #  test "Default project state", %{session: session} do
    #    session
    #    |> visit("/projects/show")
    #    |> assert_default_project_state()
    #  end
    #
    #  test "Edit project state", %{session: session} do
    #    session
    #    |> visit("/projects/show")
    #    |> click(@edit_button)
    #    |> assert_edit_project_state()
    #  end
    #
    #  test "Cancel edit project state without changes", %{session: session} do
    #    session
    #    |> visit("/projects/show")
    #    |> click(@edit_button)
    #    |> click(@cancel_button)
    #    |> assert_default_project_state()
    #  end
    #
    #  test "Save project state without changes", %{session: session} do
    #    session
    #    |> visit("/projects/show")
    #    |> click(@edit_button)
    #    |> click(@save_button)
    #    |> assert_default_project_state()
    #  end
    #
    #  test "Cancel edit project state with changes", %{session: session} do
    #    session
    #    |> visit("/projects/show")
    #    |> refute_has(@presentation_phase_selected)
    #    |> assert_has(@creation_phase_selected)
    #
    #    |> click(@edit_button)
    #    |> click(@presentation_phase_radio)
    #    |> click(@cancel_button)
    #
    #    |> assert_default_project_state()
    #    |> refute_has(@presentation_phase_selected)
    #    |> assert_has(@creation_phase_selected)
    #  end
    #
    #  test "Save project state with changes", %{session: session} do
    #    session
    #    |> visit("/projects/show")
    #    |> refute_has(@presentation_phase_selected)
    #    |> assert_has(@creation_phase_selected)
    #
    #    |> click(@edit_button)
    #    |> click(@presentation_phase_radio)
    #    |> click(@save_button)
    #    |> assert_default_project_state()
    #    |> assert_has(@presentation_phase_selected)
    #             |> refute_has(@creation_phase_selected)
    #end
  end