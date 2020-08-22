defmodule Cocu.Repo.Migrations.DonationTrigger do
  use Ecto.Migration

  def change do
    execute """
    CREATE OR REPLACE FUNCTION update_project_fund()
    RETURNS trigger AS $$
    BEGIN
      IF (TG_OP = 'INSERT') THEN
        UPDATE project SET current_fund = current_fund + NEW.value WHERE id = NEW.project_id;
        RETURN NEW;
      RETURN NULL;

      ELSIF (TG_OP = 'UPDATE') THEN
        UPDATE project SET current_fund = current_fund - OLD.value + NEW.value WHERE id = NEW.project_id;
        RETURN NEW;
      RETURN NULL;

      ELSIF (TG_OP = 'DELETE') THEN
        UPDATE project SET current_fund = current_fund + OLD.value WHERE id = NEW.project_id;
        RETURN OLD;
      RETURN NULL;
      END IF;

    END;
    $$ LANGUAGE plpgsql;
    """

    execute "DROP TRIGGER IF EXISTS update_project_fund_trg ON donation;"
    execute """
    CREATE TRIGGER update_project_fund_trg
    AFTER INSERT OR UPDATE OR DELETE
    ON donation
    FOR EACH ROW
    EXECUTE PROCEDURE update_project_fund();
    """
  end
end
