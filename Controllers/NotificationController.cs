using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Microsoft.AspNetCore.Mvc;
using SDCRMS.Models;

namespace SDCRMS.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {
        private static List<Notification> notifications = new List<Notification>();

        // Get: api/notification
        [HttpGet]
        public ActionResult<IEnumerable<Notification>> GetNotifications()
        {
            if (notifications.Count == 0)
            {
                return NotFound("Không tìm thấy thông báo nào.");
            }

            return notifications;
        }

        // Get: api/notification/{id}
        [HttpGet("{id}")]
        public ActionResult<Notification> GetNotificationById(int id)
        {
            var notification = notifications.FirstOrDefault(n => n.NotificationID == id);
            if (notification == null)
            {
                return NotFound($"Không tìm thấy thông báo có ID {id}");
            }

            return notification;
        }

        // Post: api/notification
        [HttpPost]
        public ActionResult<Notification> PostNotification(Notification notification)
        {
            var newNotification = new Notification
            {
                NotificationID =
                    notifications.Count > 0 ? notifications.Max(n => n.NotificationID) + 1 : 1,
                UserID = notification.UserID,
                Title = notification.Title,
                Message = notification.Message,
                LinkURL = notification.LinkURL,
            };
            notifications.Add(newNotification);
            return Ok(newNotification);
        }

        // PUT: api/notification/{id}
        [HttpPut("{id}")]
        public ActionResult<Notification> PutNotification(int id, Notification notification)
        {
            var notificationEdit = notifications.SingleOrDefault(n => n.NotificationID == id);
            if (notificationEdit == null)
            {
                return NotFound($"Không tìm thấy thông báo có ID {id}");
            }

            // Cập nhật các trường của thông báo
            notificationEdit.UserID = notification.UserID;
            notificationEdit.Title = notification.Title;
            notificationEdit.Message = notification.Message;
            notificationEdit.LinkURL = notification.LinkURL;

            return Ok(notificationEdit);
        }

        // DELETE: API/notification/{id}
        [HttpDelete("{id}")]
        public ActionResult DeleteNotification(int id)
        {
            var notificaltionRemove = notifications.FirstOrDefault(n => n.NotificationID == id);
            if (notificaltionRemove == null)
            {
                return NotFound($"Không tìm thấy thông báo có id: {id}");
            }
            notifications.Remove(notificaltionRemove);
            return Ok($"Xóa thành công thông báo có id: {id}");
        }
    }
}
