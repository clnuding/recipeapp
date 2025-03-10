package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

func init() {
	m.Register(func(app core.App) error {
		settings := app.Settings()

		settings.Meta.AppName = "RecipeApp"
		// settings.Meta.AppURL = "https://example.com"
		settings.Logs.MaxDays = 3
		settings.Logs.LogAuthId = true
		settings.Logs.LogIP = false

		return app.Save(settings)
	}, nil)
}
