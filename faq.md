## FAQ

**Q:** Receiving error while running `./setup.sh apply`

```bash
ERROR: (gcloud.scc.notifications.create) Organizations instance [XYZ] is the subject of a conflict: Requested entity already exists
```
**A:**  This indicates that a NotificationConfig with the same name already exists in the Organization. This could be coincidence, or may come from someone else already installing SCC Alerts in the Organization and project.

