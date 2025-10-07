using AutoMapper;
using SDCRMS.Models;
using SDCRMS.Dtos.Car;

namespace SDCRMS.Mappers
{
    public class CarProfile : Profile
    {
        public CarProfile()
        {
            CreateMap<Car, CarDTO>();
            CreateMap<CreateCarDTO, Car>();
            CreateMap<UpdateCarDTO, Car>();
        }
    }
}
