# Clinical Curator -- Admin Guide

## Demo Login

| Email | Password |
|-------|----------|
| `admin@example.com` | `admin123` |

This is a dedicated admin account. It only has access to the Admin Panel (no patient/doctor views).

---

## 1. Admin Panel Overview

### Accessing the Admin Panel

Admin access is restricted to dedicated admin accounts. These accounts are provisioned by the system administrator and cannot be created through the standard signup flow.

1. Open the Clinical Curator app.
2. Log in with your admin credentials above.
3. You will be automatically directed to the Admin Panel based on your role.

### Dashboard Stats

The Admin Panel home screen displays key metrics at a glance:

- **Pending Verifications** -- Number of practitioner applications awaiting review.
- **Approved Practitioners** -- Total number of verified practitioners on the platform.
- **Rejected Applications** -- Applications that were denied, with reasons logged.
- **Total Users** -- Overall user count across all roles (patients, practitioners, admins).

---

## 2. Practitioner Verification

### Reviewing Applications

1. From the Admin Panel, you will see the list of pending practitioner verification requests.
2. Each application card shows:
   - Applicant name
   - Submission date
   - Specialization claimed
   - Current status (Pending, Under Review, Needs Info)
3. Tap an application to open the full verification detail screen.

### Checking License Photos

On the verification detail screen:

1. Review the uploaded license photo for clarity and legibility.
2. Cross-reference the license number with the relevant medical licensing authority.
3. Verify that the name on the license matches the applicant's registered name.
4. Check the license expiry date to ensure it is still valid.

### Verification Checklist

Before approving an application, confirm the following:

- [ ] License photo is clear and readable
- [ ] License number is valid and verifiable
- [ ] Name on license matches the applicant's name
- [ ] License is not expired
- [ ] Specialization matches the license type
- [ ] Affiliated facility information is plausible
- [ ] No duplicate applications exist for this license number

### Approving, Rejecting, or Requesting More Info

**To Approve:**
1. After completing the verification checklist, tap **Approve**.
2. Add an optional note (e.g., "Verified against NMC database").
3. Confirm the approval.

**To Reject:**
1. Tap **Reject**.
2. Provide a mandatory reason for rejection (e.g., "License photo is illegible", "License number not found in registry").
3. Confirm the rejection. The applicant will be notified with your reason.

**To Request More Information:**
1. Tap **Request Info**.
2. Specify what additional documentation or clarification is needed.
3. The applicant will receive a notification and can update their application.

### What Happens on Approval

When a practitioner application is approved:

1. The applicant's user account is updated with the `doctor` or `nurse` role.
2. A **Doctor View** toggle becomes available in their Profile settings.
3. They can now switch between Patient View and Doctor View.
4. They gain access to the clinician dashboard, patient management, and scheduling features.
5. The approval is logged in the system audit trail.

---

## 3. Managing Practitioners

### Viewing Approved Practitioners

1. From the Admin Panel, navigate to the approved practitioners section.
2. Browse the list of all verified practitioners.
3. Each entry shows:
   - Practitioner name
   - Specialization
   - License number
   - Approval date
   - Current status (Active, Suspended)

### Monitoring Verification Status

- **Active** -- Practitioner is verified and operating normally.
- **Pending** -- Application is awaiting review.
- **Under Review** -- An admin has started reviewing the application.
- **Needs Info** -- Additional documentation has been requested from the applicant.
- **Rejected** -- Application was denied. The applicant can reapply with corrected information.
- **Suspended** -- A previously approved practitioner whose access has been temporarily revoked (e.g., for license expiry or compliance issues).

Admins can filter the practitioner list by any of these statuses to quickly find applications that need attention.
