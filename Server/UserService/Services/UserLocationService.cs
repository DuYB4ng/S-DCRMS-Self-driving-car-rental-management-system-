using UserService.Dtos;
using Infrastructure.Kafka;
using Infrastructure.Kafka.Messages;
using UserService.Services; // ⭐ CỰC KỲ QUAN TRỌNG

namespace UserService.Services
{
    public class UserLocationService : IUserLocationService
    {
        private readonly IKafkaProducer _producer;

        public UserLocationService(IKafkaProducer producer)
        {
            _producer = producer;
        }

        public async Task UpdateAsync(string firebaseUid, UpdateUserLocationDto dto)
        {
            var message = new UserLocationMessage
            {
                FirebaseUid = firebaseUid,
                Latitude = dto.Latitude,
                Longitude = dto.Longitude,
                Timestamp = DateTime.UtcNow
            };

            await _producer.ProduceAsync(
                topic: "user-location",
                key: firebaseUid,
                message: message
            );
        }
    }
}
