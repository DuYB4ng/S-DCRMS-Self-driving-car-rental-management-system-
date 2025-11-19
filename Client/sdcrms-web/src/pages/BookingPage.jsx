import { useState } from "react";
import BookingForm from "../components/BookingForm";
import BookingList from "../components/BookingList";

export default function BookingPage() {
  const [reload, setReload] = useState(0);

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <BookingForm onCreated={() => setReload(reload + 1)} />
      <BookingList reload={reload} />
    </div>
  );
}
