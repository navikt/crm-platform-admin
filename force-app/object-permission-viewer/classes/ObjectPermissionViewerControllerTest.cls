@IsTest
public class ObjectPermissionViewerControllerTest {

    /*  We cannot create Permission Sets in Apex, and we don't want to depend on certain
        permission metadata being present in a given environment. This means that we
        can't perform meaningful assertions in the context of object permission analysis.

        Instead, we execute the controller with both possible parameters in order to
        verify that it runs without unhandled errors and within governor limits.
     */

    @IsTest
    public static void testGetObjectPermissions () {
        ObjectPermissionViewerController.getObjectPermissions(true);
        ObjectPermissionViewerController.getObjectPermissions(false);
    }

}