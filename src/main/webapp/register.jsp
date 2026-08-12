<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Registration</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>

<body style="background:#f4f8fb;">

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-md-6">

            <div class="card p-4">

                <h2 class="text-center text-primary mb-4">
                    🏥 Patient Registration
                </h2>

                <form action="registerServlet" method="post">

                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="fullName" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="phone" class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Gender</label>

                        <select name="gender" class="form-select">
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>

                    </div>

                    <div class="mb-3">
                        <label class="form-label">Age</label>
                        <input type="number" name="age" class="form-control">
                    </div>

                    <button class="btn btn-primary w-100">
                        Register
                    </button>

                </form>

            </div>

        </div>

    </div>

</div>

</body>
</html>